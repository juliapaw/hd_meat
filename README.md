# Projekt HD

# Dane 

Źródło Danych: Dane są pobierane z Banku Danych Lokalnych (BDL) Głównego Urzędu Statystycznego (GUS). Link do strony: https://bdl.stat.gov.pl/bdl/dane/podgrup/tablica.

Format Pobierania Danych: Dla zapewnienia, że dane są organizowane w wierszach, należy je pobierać w formacie XLS (Excel Spreadsheet).


1. Uruchamiamy projekt SSIS (SQL Server Integration Services).
2. Uruchamiamy SSAS (SQL Server Analysis Services). Należy wykonać następujące kroki:
    a. Usunąć istniejące elementy.
    b. Dodać bazę danych o nazwie "HD Meat N".
    c. Dodać atrybuty do kostki analitycznej.
