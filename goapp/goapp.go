package main

import (
	"encoding/json"
	"fmt"
	"math/rand"
	"net/http"
	"time"
)

type QuoteJson struct {
	Author string `json:"author"`
	Text   string `json:"text"`
}

type QuoteResponseJson struct {
	Author string `json:"author"`
	QText  string `json:"text"`
}

type QuotesJson struct {
	QArray []QuoteJson `json:"quotes"`
}

func randomQuoteFromJsonString(w http.ResponseWriter, r *http.Request) {
	jsonStr := `[
		{ 
			"author": "Winston Churchill",
			"text": "La statistica è l’arte di mentire con esattezza."
		},
		{
			"author": "John Lennon",
			"text": "La vita è ciò che ti accade mentre sei occupate a fare altri progetti."
		},
		{
			"author": "Oscar Wilde",
			"text": "Sii te stesso; tutto il resto è già stato preso."
		},
		{
			"author": "Galileo Galilei",
			"text": "Non si può insegnare niente a un uomo; si può solo aiutarlo a scoprire ciò che ha dentro di sé."
		}
	]`

	var items []QuoteJson
	err := json.Unmarshal([]byte(jsonStr), &items)
	if err != nil {
		fmt.Println("Errore nella decodifica del JSON:", err)
		return
	}

	// Inizializza il generatore di numeri casuali con il tempo corrente come seme
	rand.Seed(time.Now().UnixNano())

	// Sceglie un elemento casuale dall'array
	randomItem := items[rand.Intn(len(items))]

	json.NewEncoder(w).Encode(QuoteResponseJson{randomItem.Author, randomItem.Text})

}

func main() {
	http.HandleFunc("/", randomQuoteFromJsonString)
	http.ListenAndServe(":80", nil)
}
