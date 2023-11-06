include shared-gdrive(
"dcic-2021",
  "1wyQZj_L0qqV9Ekgr9au6RX2iqt2Ga8Ep") 

include gdrive-sheets
include data-source
ssid = "1RYN0i4Zx_UETVuYacgaGfnFcv4l9zd9toQTTdkQkj7g"
energiforbrukstabellen =
  load-table: komponent, energi
    source: load-spreadsheet(ssid).sheet-by-name("kWh", true)
    sanitize energi using string-sanitizer #Oppgave a)
  end #Bruker sanitize ved å utvide Kodeeksempel 1 og få kolonnedata for kolonnen energi returnert som data av typen String.

energiforbrukstabellen


#Oppgave b og c)
fun energi-to-number(s :: String) -> Number: #Definerer en funksjon som Overfører data fra typen String til Number
  
  cases(Option) string-to-number(s):
    |some(a) => a
    |none => 0
  end 
where: #Endrer bestemt kollonedata fra tekst til tall.
  energi-to-number("") is 0
  energi-to-number("30") is 30
  energi-to-number("37") is 37
  energi-to-number("5") is 5
  energi-to-number("4") is 4
  energi-to-number("15") is 15
  energi-to-number("48") is 48
  energi-to-number("12") is 12
  energi-to-number("4") is 4
end 


nytabell = transform-column(energiforbrukstabellen, "energi", energi-to-number)
nytabell #utskrift av den nye tabellen med nye de nye nummererte kollonedataene.



#Oppgave d) 
fun sum-on-energi(): #Definerer en funksjon for sum av all energien komponentene produserer. Bruker transform-column funksjonen med de nye nummererte verdiene i energi-kollonene fra energiforbrukstabellen og summerer.
  t = transform-column(energiforbrukstabellen, "energi", energi-to-number)
  sum(t, "energi") 
  end


sum-on-energi() #Definisjonsvinduet skriver ut summen av kWh for alle komponentene (155).

#Definerer gjennomsnittlig kwh-bilforbruk per person i industrilandet Norge.
utslippstabell-norge = transform-column(nytabell, "bil", energi-to-number) 

distance = 15
distance-per-drivstoff-enhet = 1.5
energi-per-enhet = 2

energi-per-dag = (distance / distance-per-drivstoff-enhet) * energi-per-enhet

fun norge-bilforbruk(value :: Number) -> Number:
  if value == 0: energi-per-dag 
  else: value 
  end 
end

t2 = transform-column(utslippstabell-norge, "energi", norge-bilforbruk)
sum-on-energi() + energi-per-dag #Skriver ut summen av kWh for alle komponenter inkuldert gjennomsnittlig energiforbruk per person i Norge (175). 


#Oppgave e) Visualisering av data fra tabellen. 
chart = table: komponent :: String, energi :: Number
  row: "bil", 20
  row: "fly", 30
  row: "ovn", 37
  row: "lys", 5
  row: "dingser", 4
  row: "mlk", 15
  row: "varer", 48
  row: "varetransport", 12
  row: "offtjen", 4
end

bar-chart(chart, "komponent", "energi")  #skriver ut nytabell som et image.
