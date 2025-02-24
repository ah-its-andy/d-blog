package main

import (
	"net/http"
)

func main() {
	fs := http.FileServer(http.Dir("../"))
	http.Handle("/", fs)

	println("Server is running at http://localhost:8080")
	http.ListenAndServe(":8080", nil)
}
