# Il Taccuino delle Icone

Piccola web app installabile per cercare icone e foto JPG, vedere un'anteprima e scaricarle in PNG, JPG o ICO. Le icone vengono cercate online tramite [Iconify](https://iconify.design/), le foto JPG tramite [Wikimedia Commons](https://commons.wikimedia.org/) e le ricerche vengono tradotte dall'italiano all'inglese tramite [MyMemory](https://mymemory.translated.net/). Il testo della ricerca viene inviato a questi servizi; traduzione, ricerca e download richiedono una connessione a Internet. Se il servizio di traduzione non è disponibile, l'app prova comunque con il testo originale e le traduzioni locali per alcune parole comuni.

## Avvio su Windows

1. Fai doppio clic su `Avvia Cerca Icone.bat`.
2. Si apre l'app nel browser. Lascia aperta la finestra PowerShell mentre la usi.
3. Per installarla, usa **Installa app** se compare il pulsante, oppure il comando di installazione del browser (per esempio dal menu del browser).
4. Per chiudere il server, torna alla finestra PowerShell e premi `Ctrl+C`.

Non serve installare dipendenze. L'app funziona offline dopo il primo caricamento, ma ricerca e download richiedono la rete.

## Pubblicazione con GitHub Pages

Il workflow in `.github/workflows/deploy-pages.yml` pubblica automaticamente l'app su GitHub Pages quando viene aggiornato il branch `main`. Nelle impostazioni del repository, apri **Settings > Pages** e seleziona **GitHub Actions** come sorgente di pubblicazione. L'indirizzo del sito apparirà nella stessa pagina dopo il completamento del workflow.

Una volta pubblicata, apri l'indirizzo con Edge o Chrome e scegli **Installa app** dal menu del browser per installarla su Windows.

## Formati

Il PNG viene creato a 256 × 256 pixel con sfondo trasparente. Il JPG di un'icona viene creato a 256 × 256 pixel con sfondo bianco, perché il formato non supporta la trasparenza. Nella modalità **Foto JPG** puoi cercare e scaricare fotografie JPG originali da Wikimedia Commons; verifica sempre la licenza e le attribuzioni indicate per ciascun file. Il file ICO contiene un PNG a 256 × 256 pixel incorporato ed è compatibile con i lettori di icone moderni.
