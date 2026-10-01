<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/kerf-lockup-on-dark.svg">
    <img src="assets/kerf-lockup.svg" alt="Kerf" height="72">
  </picture>
</p>

# Kerf releases

Hier staan alleen de releases van Kerf, een lichte notch-app voor macOS: muziek met doorspoelen, een shelf voor bestanden, AirDrop via de notch, batterij-meldingen en een eigen volume/helderheid-HUD. De code zelf is privé.

## Installeren

Open Terminal (Programma's > Hulpprogramma's > Terminal), plak deze regel en druk op Return:

    curl -fsSL https://raw.githubusercontent.com/BEMBOOMER/kerf-releases/main/install.sh | bash

Het script haalt de nieuwste Kerf van deze pagina, controleert de zip met de SHA-256 uit de release-notities, kijkt of de handtekening klopt en zet Kerf in Programma's. Daarna staat hij meteen aan: wijs naar de notch. Wil je eerst zien wat het doet, lees dan [install.sh](install.sh); het is kort.

Kerf werkt op macOS 14 of nieuwer, op Macs met Apple silicon.

### Waarom niet gewoon de zip?

Kerf is niet door Apple genotariseerd. Download je de zip met je browser, dan krijgt hij een quarantainevlag en houdt macOS hem tegen: Apple kan niet verifiëren dat Kerf vrij is van malware. Een download via Terminal krijgt die vlag niet. Daarom controleert het script zelf of de download klopt, net als de updater in Kerf.

### Toch met de hand

Download de zip bij [Releases](https://github.com/BEMBOOMER/kerf-releases/releases/latest), pak hem uit en zet Kerf.app in Programma's. De eerste keer openen gaat zo:

- **macOS 14**: klik met rechts op Kerf en kies Open.
- **macOS 15 en nieuwer**: open Kerf, klik op Gereed, ga naar Systeeminstellingen > Privacy en beveiliging en kies bij Kerf voor Open toch (Open Anyway). Bevestig met je wachtwoord.

Al tegengehouden? Deze regel in Terminal haalt de vlag eraf, daarna opent Kerf gewoon:

    xattr -dr com.apple.quarantine /Applications/Kerf.app

## Updates

Kerf kijkt ongeveer één keer per dag of hier een nieuwere versie staat. Is die er, dan zie je een melding onder de notch en een stipje op het tandwiel; installeren doe je zelf via het tandwiel. Elke release bevat een zip en de SHA-256 daarvan in de notities, en Kerf installeert niets zonder kloppende controlesom en geldige handtekening.

## Rechten

Alleen voor de volume- en helderheid-HUD vraagt Kerf om Toegankelijkheid. Zeg je nee, dan werkt de rest gewoon en zie je de normale pop-up van macOS. Na een update vraagt macOS daar opnieuw om: haal Kerf in die lijst weg met de min-knop en voeg hem opnieuw toe. Muziek, shelf, AirDrop en batterij vragen niks, en Kerf praat alleen met GitHub, om te kijken of er een update is.
