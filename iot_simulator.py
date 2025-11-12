#!/usr/bin/env python3
"""
Simulateur IoT pour Smart Water Monitoring
Ce script génère des données de consommation d'eau pour tous les capteurs
IoT présents dans la base de données et les envoie au backend Java.

Prérequis:
    pip install requests

Usage:
    python iot_simulator.py
    
    Ou avec paramètres personnalisés:
    python iot_simulator.py --url http://localhost:8080/SmartWaterMonitoring --interval 5
"""

import requests
import random
import time
import json
import argparse
from datetime import datetime
from typing import List, Optional

# Configuration par défaut
DEFAULT_BASE_URL = "http://localhost:8080/SmartWaterMonitoring"
DEFAULT_INTERVAL = 60  # secondes entre chaque envoi (1 minute - plus réaliste)
MIN_CONSOMMATION = 0.1  # Litres (minimum - consommation résiduelle)
MAX_CONSOMMATION = 50.0  # Litres (maximum)
ALERT_PROBABILITY = 0.03  # 3% de chance de générer une alerte (encore plus faible et réaliste)

# Patterns de consommation selon l'heure de la journée
PEAK_HOURS = [7, 8, 12, 13, 19, 20, 21]  # Heures de pointe
LOW_HOURS = [1, 2, 3, 4, 5, 23]  # Heures creuses
PEAK_MULTIPLIER = 2.0  # Consommation x2 aux heures de pointe
LOW_MULTIPLIER = 0.3  # Consommation x0.3 aux heures creuses

class IoTSimulator:
    """Simulateur de capteurs IoT pour la consommation d'eau"""
    
    def __init__(self, base_url: str = DEFAULT_BASE_URL, interval: int = DEFAULT_INTERVAL):
        """
        Initialise le simulateur
        
        Args:
            base_url: URL de base de l'application (ex: http://localhost:8080/SmartWaterMonitoring)
            interval: Intervalle en secondes entre chaque envoi de données
        """
        self.base_url = base_url.rstrip('/')
        self.interval = interval
        self.capteur_ids: List[int] = []
        self.session = requests.Session()
        self.running = False
        
        # URLs des endpoints
        self.discovery_url = f"{self.base_url}/capteurs?action=listJson"
        self.data_url = f"{self.base_url}/api/waterdata"
        self.alert_url = f"{self.base_url}/api/alertes"
        
        # Statistiques pour les alertes
        self.alert_count = 0
        
        print("=" * 60)
        print("🌊 Simulateur IoT Smart Water Monitoring".center(60))
        print("=" * 60)
        print(f"📡 URL Backend: {self.base_url}")
        print(f"⏱️  Intervalle: {self.interval} secondes")
        print("=" * 60)
    
    def discover_capteurs(self) -> bool:
        """
        Découvre tous les capteurs disponibles via l'API
        
        Returns:
            True si des capteurs ont été trouvés, False sinon
        """
        print("\n🔍 Découverte des capteurs IoT...")
        
        try:
            response = self.session.get(self.discovery_url, timeout=10)
            
            if response.status_code == 200:
                self.capteur_ids = response.json()
                
                if not self.capteur_ids:
                    print("⚠️  Aucun capteur trouvé dans la base de données")
                    return False
                
                print(f"✅ {len(self.capteur_ids)} capteur(s) découvert(s): {self.capteur_ids}")
                return True
            else:
                print(f"❌ Erreur HTTP {response.status_code}: {response.text}")
                return False
                
        except requests.exceptions.ConnectionError:
            print(f"❌ Impossible de se connecter à {self.discovery_url}")
            print("   Vérifiez que le serveur est démarré et accessible")
            return False
        except requests.exceptions.Timeout:
            print("❌ Timeout lors de la connexion au serveur")
            return False
        except Exception as e:
            print(f"❌ Erreur lors de la découverte: {str(e)}")
            return False
    
    def generate_water_data(self) -> float:
        """
        Génère une valeur de consommation d'eau réaliste selon l'heure de la journée
        
        Returns:
            Valeur de consommation en litres
        """
        current_hour = datetime.now().hour
        
        # Déterminer le multiplicateur selon l'heure
        if current_hour in PEAK_HOURS:
            # Heures de pointe (matin, midi, soir)
            multiplier = PEAK_MULTIPLIER
            base_mean = 20.0  # Base plus élevée
        elif current_hour in LOW_HOURS:
            # Heures creuses (nuit)
            multiplier = LOW_MULTIPLIER
            base_mean = 5.0  # Base très faible
        else:
            # Heures normales
            multiplier = 1.0
            base_mean = 12.0  # Base moyenne
        
        # Génère une valeur avec une distribution normale
        std_dev = base_mean / 3
        value = random.gauss(base_mean, std_dev) * multiplier
        
        # Ajouter une petite variation aléatoire (±10%)
        variation = random.uniform(0.9, 1.1)
        value = value * variation
        
        # S'assurer que la valeur est dans les limites
        value = max(MIN_CONSOMMATION, min(MAX_CONSOMMATION, value))
        
        return round(value, 2)
    
    def send_data(self, capteur_id: int, valeur_consommation: float) -> bool:
        """
        Envoie une donnée de consommation au serveur
        
        Args:
            capteur_id: ID du capteur
            valeur_consommation: Valeur de consommation en litres
            
        Returns:
            True si l'envoi a réussi, False sinon
        """
        payload = {
            "capteurId": capteur_id,
            "valeurConsommation": valeur_consommation
        }
        
        try:
            response = self.session.post(
                self.data_url,
                json=payload,
                headers={'Content-Type': 'application/json'},
                timeout=10
            )
            
            timestamp = datetime.now().strftime("%H:%M:%S")
            
            if response.status_code in [200, 201]:
                print(f"[{timestamp}] ✅ Capteur #{capteur_id}: {valeur_consommation}L envoyé")
                return True
            else:
                print(f"[{timestamp}] ❌ Capteur #{capteur_id}: Erreur {response.status_code}")
                print(f"   Réponse: {response.text}")
                return False
                
        except requests.exceptions.ConnectionError:
            print(f"❌ Connexion perdue avec le serveur")
            return False
        except requests.exceptions.Timeout:
            print(f"❌ Timeout lors de l'envoi des données")
            return False
        except Exception as e:
            print(f"❌ Erreur lors de l'envoi: {str(e)}")
            return False
    
    def generate_alert(self, capteur_id: int, valeur_consommation: float, seuil_alerte: float = 30.0) -> Optional[dict]:
        """
        Génère une alerte si les conditions sont remplies de manière réaliste
        
        Args:
            capteur_id: ID du capteur
            valeur_consommation: Valeur de consommation actuelle
            seuil_alerte: Seuil au-delà duquel générer une alerte
            
        Returns:
            Dictionnaire avec les données de l'alerte ou None
        """
        current_hour = datetime.now().hour
        
        # Ajuster la probabilité d'alerte selon l'heure
        # Plus probable aux heures de pointe (problèmes détectés quand on utilise l'eau)
        if current_hour in PEAK_HOURS:
            adjusted_probability = ALERT_PROBABILITY * 1.5
        elif current_hour in LOW_HOURS:
            adjusted_probability = ALERT_PROBABILITY * 0.5
        else:
            adjusted_probability = ALERT_PROBABILITY
        
        # Vérifier si on doit générer une alerte (faible probabilité)
        if random.random() > adjusted_probability:
            return None
        
        # Types d'alertes possibles avec conditions plus réalistes
        alert_types = [
            {
                "type": "SEUIL_DEPASSE",
                "message": f"Consommation anormale détectée: {valeur_consommation}L (seuil: {seuil_alerte}L)",
                "urgence": "ELEVEE" if valeur_consommation > seuil_alerte * 1.5 else "MOYENNE",
                "condition": valeur_consommation > seuil_alerte and current_hour not in PEAK_HOURS  # Anormal si pas en heure de pointe
            },
            {
                "type": "FUITE_DETECTEE",
                "message": f"Suspicion de fuite: Consommation continue détectée ({valeur_consommation}L)",
                "urgence": "ELEVEE",
                "condition": valeur_consommation > 40.0 or (valeur_consommation > 15.0 and current_hour in LOW_HOURS)  # Très élevée ou élevée la nuit
            },
            {
                "type": "CAPTEUR_OFFLINE",
                "message": "Perte de communication avec le capteur",
                "urgence": "MOYENNE",
                "condition": random.random() < 0.05  # 5% de chance parmi les alertes (plus rare)
            }
        ]
        
        # Sélectionner une alerte dont la condition est remplie
        valid_alerts = [alert for alert in alert_types if alert["condition"]]
        
        if not valid_alerts:
            return None
        
        alert = random.choice(valid_alerts)
        
        return {
            "capteurId": capteur_id,
            "type": alert["type"],
            "message": alert["message"],
            "niveauUrgence": alert["urgence"]
        }
    
    def send_alert(self, alert_data: dict) -> bool:
        """
        Envoie une alerte au serveur
        
        Args:
            alert_data: Données de l'alerte
            
        Returns:
            True si l'envoi a réussi, False sinon
        """
        try:
            response = self.session.post(
                self.alert_url,
                json=alert_data,
                headers={'Content-Type': 'application/json'},
                timeout=10
            )
            
            timestamp = datetime.now().strftime("%H:%M:%S")
            
            if response.status_code in [200, 201]:
                self.alert_count += 1
                print(f"[{timestamp}] 🚨 ALERTE générée: {alert_data['type']} - Capteur #{alert_data['capteurId']}")
                print(f"   └─ {alert_data['message']}")
                return True
            else:
                print(f"[{timestamp}] ❌ Erreur envoi alerte {response.status_code}")
                return False
                
        except Exception as e:
            print(f"❌ Erreur lors de l'envoi de l'alerte: {str(e)}")
            return False
    
    def run_simulation(self):
        """
        Lance la simulation en continu
        """
        print("\n" + "=" * 60)
        print("🚀 Démarrage de la simulation".center(60))
        print("   (Appuyez sur Ctrl+C pour arrêter)".center(60))
        print("=" * 60 + "\n")
        
        self.running = True
        iteration = 0
        success_count = 0
        error_count = 0
        
        try:
            while self.running:
                iteration += 1
                
                # Sélectionner un capteur au hasard
                capteur_id = random.choice(self.capteur_ids)
                
                # Générer une valeur de consommation réaliste selon l'heure
                valeur_consommation = self.generate_water_data()
                
                # Afficher l'heure actuelle pour le contexte
                current_time = datetime.now()
                time_indicator = "🌙" if current_time.hour in LOW_HOURS else ("☀️" if current_time.hour in PEAK_HOURS else "🕐")
                
                # Envoyer les données
                if self.send_data(capteur_id, valeur_consommation):
                    success_count += 1
                    
                    # Tenter de générer une alerte (faible probabilité)
                    alert_data = self.generate_alert(capteur_id, valeur_consommation)
                    if alert_data:
                        self.send_alert(alert_data)
                else:
                    error_count += 1
                
                # Afficher les statistiques toutes les 5 itérations (au lieu de 10)
                if iteration % 5 == 0:
                    print("\n" + "-" * 60)
                    hour_status = "Heures de POINTE ☀️" if current_time.hour in PEAK_HOURS else (
                        "Heures CREUSES 🌙" if current_time.hour in LOW_HOURS else "Heures normales 🕐"
                    )
                    print(f"📊 Statistiques: {iteration} envois | "
                          f"✅ {success_count} réussis | ❌ {error_count} erreurs | "
                          f"🚨 {self.alert_count} alertes")
                    print(f"⏰ {current_time.strftime('%H:%M:%S')} - {hour_status}")
                    print("-" * 60 + "\n")
                
                # Attendre avant le prochain envoi
                time.sleep(self.interval)
                
        except KeyboardInterrupt:
            print("\n\n" + "=" * 60)
            print("🛑 Arrêt de la simulation".center(60))
            print("=" * 60)
            print(f"\n📊 Statistiques finales:")
            print(f"   Total d'envois: {iteration}")
            print(f"   ✅ Succès: {success_count} ({success_count/iteration*100:.1f}%)" if iteration > 0 else "")
            print(f"   ❌ Erreurs: {error_count} ({error_count/iteration*100:.1f}%)" if iteration > 0 else "")
            print(f"   🚨 Alertes générées: {self.alert_count}")
            print("\n👋 Au revoir!\n")
            self.running = False
    
    def start(self):
        """
        Démarre le simulateur
        """
        # Découvrir les capteurs
        if not self.discover_capteurs():
            print("\n❌ Impossible de démarrer le simulateur sans capteurs")
            print("   Assurez-vous que:")
            print("   1. Le serveur Tomcat est démarré")
            print("   2. Des capteurs IoT existent dans la base de données")
            print("   3. L'URL est correcte\n")
            return False
        
        # Lancer la simulation
        self.run_simulation()
        return True


def main():
    """Point d'entrée principal du script"""
    
    parser = argparse.ArgumentParser(
        description="Simulateur IoT pour Smart Water Monitoring",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Exemples d'utilisation:
  # Configuration par défaut (localhost:8080, intervalle 10s)
  python iot_simulator.py
  
  # Personnaliser l'URL
  python iot_simulator.py --url http://192.168.1.10:8080/SmartWaterMonitoring
  
  # Personnaliser l'intervalle (5 secondes)
  python iot_simulator.py --interval 5
  
  # URL et intervalle personnalisés
  python iot_simulator.py --url http://exemple.com/app --interval 2
        """
    )
    
    parser.add_argument(
        '--url',
        type=str,
        default=DEFAULT_BASE_URL,
        help=f"URL de base de l'application (défaut: {DEFAULT_BASE_URL})"
    )
    
    parser.add_argument(
        '--interval',
        type=int,
        default=DEFAULT_INTERVAL,
        help=f"Intervalle en secondes entre chaque envoi (défaut: {DEFAULT_INTERVAL})"
    )
    
    args = parser.parse_args()
    
    # Créer et démarrer le simulateur
    simulator = IoTSimulator(base_url=args.url, interval=args.interval)
    simulator.start()


if __name__ == "__main__":
    main()
