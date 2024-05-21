# Progetto-Reti-Logiche

## Team 👥

- [Jaskaran Ram](https://github.com/JaskaranRam)
- [Lorenzo Reitani](https://github.com/LorenzoReitani)

## Scopo del Progetto 

Il progetto da noi sostenuto consiste nel descrivere un componente hardware, in stile behavioural 
in VHDL attraverso il software Vivado, in grado di leggere dati da un dispositivo di memoria esterno 
e mostrare in uscita, quando richiesto, il valore letto su una porta specifica tra le 4 disponibili, 
mentre le altre 3 porte continueranno a mostrare in uscita il loro ultimo valore trasmesso. La 
procedura di mettere in output dei valori dal nostro componente viene scandita con l’assunzione 
del valore 1 dell’uscita o_done. L’indirizzo di memoria dove prendere le informazioni e la rispettiva 
porta su cui trasmettere l’output vengono stabiliti da un segnale seriale ricevuto in input (i_w), il 
quale verrà processato e interpretato secondo le specifiche all’interno del componente ciclo per 
ciclo. 

30/30
