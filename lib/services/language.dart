class LanguageService {
  String language;
  Map<String, String> dictionary;

  LanguageService(
      {required this.language, this.dictionary = const <String, String>{}});

  static LanguageService getInstance(String language) {
    LanguageService lang = LanguageService(language: language);
    lang.dictionary = readJsonFile(language); // TODO: read from JSON file
    return lang;
  }

  static Map<String, String> readJsonFile(String language) {
    switch (language) {
      case "en":
        dynamic jsonEN = {
          "project_title": "Graduation thesis",
          "users": "Users",
          "estates": "Estates",
          "profile_page": "Profile page",
          "change_password": "Change password",
          "delete_account": "Delete account",
          "sign_out": "Sign out",
          "loading": "Loading",
          "save_changes": "Save changes",
          "personal_information": "Personal information",
          "your_address": "Your address",
          "preferences": "Preferences",
          "obtaining_user_information":
              "Obtaining your information. Please wait.",
          "firstname": "First name",
          "owner_firstname": "Owner's first name",
          "lastname": "Last name",
          "owner_lastname": "Owner's last name",
          "date_of_birth": "Date of birth",
          "company_name": "Company's name",
          "phone_number": "Phone number",
          "street": "Street",
          "zip": "Zip",
          "city": "City",
          "country": "Country",
          "distance_units": "Distance units",
          "km": "Kilometers",
          "mi": "Miles",
          "temperature_units": "Temperature units",
          "date_formats": "Date formats",
          "en": "English",
          "de": "German",
          "hr": "Croatian",
          "language": "Language",
          "account_successfully_updated":
              "Your account has successfully been updated!",
          "dismiss": "Dismiss",
          "error_while_updating_user":
              "There was an error while updating your account. Please try again (later)...",
          "profile_image": "Profile image",
          "background_image": "Background image",
          "discard_image": "Discard image",
          "dropzone_text": "Drop images here or browse through files",
          "no_estates": "There are no estates to display!",
          "list": "List",
          "map": "Map",
          "manage_presentation": "Manage presentation",
          "general_information": "General information",
          "additional_information": "Additional information",
          "description": "Description",
          "create_estate": "Create estate",
          "add_new_estate": "Add a new estate",
          "search_text":
              "Here you can search for names, emails and phone numbers",
          "additional_filters": "Additional filters",
          "number_of_estates": "Number of estates",
          "from": "From",
          "to": "To",
          "blocked": "Blocked",
          "individual": "Individual",
          "banned": "Banned",
          "company": "Company",
          "apply_filters": "Apply filters",
          "image": "Image",
          "name": "Name",
          "type": "Type",
          "users_per_page": "Users per page",
          "scroll_to_top": "Scroll to top",
          "allow_pets": "Allow pets",
          "allow_smoking": "Allow smoking",
          "air_conditioning": "Air conditioning",
          "handicap_accessible": "Handicap accessible",
          "designated_parking_spots": "Designated parking spots",
          "outlet_type": "Outlet type",
          "house_orientation": "House orientation",
          "accepting_payment_cards": "Accepting payment cards",
          "wifi": "Wifi",
          "pool": "Pool",
          "kitchen": "Kitchen",
          "washing_machine": "Washing machine",
          "drying_machine": "Drying machine",
          "edit_presentation": "Edit presentation",
          "delete_estate": "Delete estate",
          "delete_estate_warning_message":
              "Are you sure you want to delete your estate?",
          "cancel": "Cancel",
          "choose_file": "Choose file",
          "no_file": "No file",
          "cannot_preview": "Cannot preview",
          "save_image": "Save image",
          "banned_by_admin":
              "Your account has been banned by the admin. You can contact the admin at admin@diplomski.com for more information.",
          "blocked_by_admin":
              "Your account is currently blocked by the admin. You can contact the admin at admin@diplomski.com for more information.",
          "cant_log_in":
              "There was an error while logging in. Please try again (later)...",
          "successful_login": "You have successfully logged in!",
          "sign_up": "Sign up",
          "type_of_customer": "Type of customer",
          "password": "Password",
          "repeat_password": "Repeat password",
          "keep_me_logged_in": "Keep me logged in.",
          "have_account_login_here": "Already have an account? Sign in here.",
          "cant_register":
              "There is a problem while trying to create your account. Please try again later.",
          "account_successfully_created":
              "Your account gas successfully been created!",
          "dont_have_account_register_here":
              "Don't have an account? Sign up here.",
          "sign_in": "Sign in",
          "sign_in_with_google": "Sign in with Google",
          "sign_in_with_facebook": "Sign in with Facebook",
          "customers": "Customers",
          "old_password": "Old password",
          "new_password": "New password",
          "delete_account_warning_message":
              "Are you sure you want to delete your account? Your data will be permanently lost!",
          "avatar_image": "Avatar image",
          "or": "or",
          "email": "Email",
          "show": "Show",
          "dont_show": "Don't show",
        };

        /*if (specific != null && specific.isNotEmpty) {
          if (jsonEN[specific] != null) {
            return {specific: jsonEN[specific]} as Map<String, String>;
          }
          return {specific: ""};
        }*/
        return jsonEN as Map<String, String>;
      case "de":
        dynamic jsonDE = {
          "project_title": "Abschlussarbeit",
          "users": "Benutzer",
          "estates": "Immobilien",
          "profile_page": "Profilseite",
          "change_password": "Passwort ändern",
          "delete_account": "Konto löschen",
          "sign_out": "Abmelden",
          "loading": "Wird geladen",
          "save_changes": "Änderungen speichern",
          "personal_information": "Persönliche Angaben",
          "your_address": "Deine Adresse",
          "preferences": "Präferenzen",
          "obtaining_user_information":
              "Einholen Ihrer Informationen. Bitte warten.",
          "firstname": "Vorname",
          "owner_firstname": "Vorname des Besitzers",
          "lastname": "Nachname",
          "owner_lastname": "Nachname des Besitzers",
          "date_of_birth": "Geburtsdatum",
          "company_name": "Firmenname",
          "phone_number": "Telefonnummer",
          "street": "Straße",
          "zip": "Reißverschluss",
          "city": "Stadt",
          "country": "Land",
          "distance_units": "Entfernungseinheiten",
          "km": "Kilometer",
          "mi": "Meilen",
          "temperature_units": "Temperatureinheiten",
          "date_formats": "Datumsformate",
          "en": "Englisch",
          "de": "Deutsch",
          "hr": "Kroatische",
          "language": "Sprache",
          "account_successfully_updated":
              "Ihr Konto wurde erfolgreich aktualisiert!",
          "dismiss": "Zurückweisen",
          "error_while_updating_user":
              "Beim Aktualisieren Ihres Kontos ist ein Fehler aufgetreten. Bitte versuchen Sie es (später) noch einmal...",
          "profile_image": "Profilbild",
          "background_image": "Hintergrundbild",
          "discard_image": "Bild verwerfen",
          "dropzone_text":
              "Legen Sie hier Bilder ab oder durchsuchen Sie die Dateien",
          "no_estates": "Es sind keine Immobilien zum Anzeigen vorhanden!",
          "list": "Aufführen",
          "map": "Karte",
          "manage_presentation": "Präsentation verwalten",
          "general_information": "Allgemeine Informationen",
          "additional_information": "Weitere Informationen",
          "description": "Beschreibung",
          "create_estate": "Immobilien schaffen",
          "add_new_estate": "Fügen Sie eine neue Immobilie hinzu",
          "search_text":
              "Hier können Sie nach Namen, E-Mails und Telefonnummern suchen",
          "additional_filters": "Zusätzliche Filter",
          "number_of_estates": "Anzahl der Nachlässe",
          "from": "Aus",
          "to": "Zu",
          "blocked": "Verstopft",
          "individual": "Individuell",
          "banned": "Verboten",
          "company": "Unternehmen",
          "apply_filters": "Wenden Sie Filter an",
          "image": "Bild",
          "name": "Name",
          "type": "Typ",
          "users_per_page": "Benutzer pro Seite",
          "scroll_to_top": "Nach oben scrollen",
          "allow_pets": "Haustiere sind erlaubt",
          "allow_smoking": "Rauchen erlauben",
          "air_conditioning": "Klimaanlage",
          "handicap_accessible": "Behindertengerecht",
          "designated_parking_spots": "Ausgewiesene Parkplätze",
          "outlet_type": "Steckdosentyp",
          "house_orientation": "Hausorientierung",
          "accepting_payment_cards": "Akzeptieren von Zahlungskarten",
          "wifi": "Wifi",
          "pool": "Schwimmbad",
          "kitchen": "Küche",
          "washing_machine": "Waschmaschine",
          "drying_machine": "Trockner",
          "edit_presentation": "Präsentation bearbeiten",
          "delete_estate": "Immobilien löschen",
          "delete_estate_warning_message":
              "Sind Sie sicher, dass Sie Ihre Immobilie löschen möchten?",
          "cancel": "Abbrechen",
          "choose_file": "Datei wählen",
          "no_file": "Keine datei",
          "cannot_preview": "Vorschau nicht möglich",
          "save_image": "Bild speichern",
          "banned_by_admin":
              "Ihr Konto wurde vom Administrator gesperrt. Für weitere Informationen können Sie den Administrator unter admin@diplomski.com kontaktieren.",
          "blocked_by_admin":
              "Ihr Konto ist derzeit vom Administrator gesperrt. Für weitere Informationen können Sie den Administrator unter admin@diplomski.com kontaktieren.",
          "cant_log_in":
              "Beim Anmelden ist ein Fehler aufgetreten. Bitte versuchen Sie es später erneut ...",
          "successful_login": "Sie haben sich erfolgreich angemeldet!",
          "customers": "Kunden",
          "old_password": "Altes Passwort",
          "new_password": "Neue Passwort",
          "repeat_password": "Passwort wiederholen",
          "type_of_customer": "Kundentyp",
          "password": "Passwort",
          "delete_account_warning_message":
              "Sind Sie sicher, dass Sie Ihr Konto löschen möchten? Ihre Daten gehen dauerhaft verloren!",
          "sign_up": "Anmelden",
          "have_account_login_here":
              "Haben Sie bereits ein Konto? Melden Sie sich hier an.",
          "keep_me_logged_in": "Eingeloggt bleiben.",
          "cant_register":
              "Beim Versuch, Ihr Konto zu erstellen, ist ein Problem aufgetreten. Bitte versuchen Sie es später erneut.",
          "account_successfully_created":
              "Ihr Gaskonto wurde erfolgreich erstellt!",
          "dont_have_account_register_here":
              "Sie haben noch kein Konto? Melden Sie sich hier an.",
          "sign_in": "Anmelden",
          "sign_in_with_google": "Mit Google anmelden",
          "sign_in_with_facebook": "Mit Facebook anmelden",
          "avatar_image": "Profilbild",
          "or": "oder",
          "email": "Email",
          "show": "Zeigen",
          "dont_show": "Nicht zeigen",
        };

        /*if (specific != null && specific.isNotEmpty) {
          if (jsonDE[specific] != null) {
            return {specific: jsonDE[specific]} as Map<String, String>;
          }
          return {specific: ""};
        }*/
        return jsonDE as Map<String, String>;
      case "hr":
        dynamic jsonHR = {
          "project_title": "Diplomski rad",
          "users": "Korisnici",
          "estates": "Nekretnina",
          "profile_page": "Stranica profila",
          "change_password": "Promijeni lozinku",
          "delete_account": "Izbriši račun",
          "sign_out": "Odjavi se",
          "loading": "Učitavanje",
          "save_changes": "Spremi izmjene",
          "personal_information": "Osobni podatci",
          "your_address": "Vaša adresa",
          "preferences": "Postavke",
          "obtaining_user_information":
              "Dobivanje vaših podataka. Molimo pričekajte.",
          "firstname": "Ime",
          "owner_firstname": "Ime vlasnika",
          "lastname": "Prezime",
          "owner_lastname": "Prezime vlasnika",
          "date_of_birth": "Datum rođenja",
          "company_name": "Naziv tvrtke",
          "phone_number": "Broj telefona",
          "street": "Ulica",
          "zip": "Poštanski broj",
          "city": "Grad",
          "country": "Država",
          "distance_units": "Jedinice udaljenosti",
          "km": "Kilometri",
          "mi": "Milje",
          "temperature_units": "Jedinice za temperaturu",
          "date_formats": "Formati datuma",
          "en": "Engleski",
          "de": "Njemački",
          "hr": "Hrvatski",
          "language": "Jezik",
          "account_successfully_updated": "Vaš račun je uspješno ažuriran!",
          "dismiss": "Odbaci",
          "error_while_updating_user":
              "Došlo je do pogreške prilikom ažuriranja vašeg računa. Molimo pokušajte ponovo (kasnije)...",
          "profile_image": "Profilna slika",
          "background_image": "Pozadinska slika",
          "discard_image": "Odbaci sliku",
          "dropzone_text": "Ovdje ispustite slike ili pregledajte datoteke",
          "no_estates": "Nema nekretnina za prikaz!",
          "list": "Popis",
          "map": "Karta",
          "manage_presentation": "Upravljanje prezentacijom",
          "general_information": "Opće informacije",
          "additional_information": "Dodatne information",
          "description": "Opis",
          "create_estate": "Stvorite nekretnine",
          "add_new_estate": "Dodajte novu nekretninu",
          "search_text":
              "Ovdje možete pretraživati imena, adrese e-pošte i telefonske brojeve",
          "additional_filters": "Dodatni filteri",
          "number_of_estates": "Broj imanja",
          "from": "Od",
          "to": "Do",
          "blocked": "Blokiran",
          "individual": "Pojedinac",
          "banned": "Zabranjeno",
          "company": "Firma",
          "apply_filters": "Primijeni filtre",
          "image": "Slika",
          "name": "Ime",
          "type": "Tip",
          "users_per_page": "Korisnici po stranici",
          "scroll_to_top": "Pomaknite se na vrh",
          "allow_pets": "Dozvoljeni kućne ljubimce",
          "allow_smoking": "Dozvoljeni pušenje",
          "air_conditioning": "Klimatizacija",
          "handicap_accessible": "Pristupačno osobama s invaliditetom",
          "designated_parking_spots": "Određena parkirna mjesta",
          "outlet_type": "Vrsta izlaza",
          "house_orientation": "Orijentacija kuće",
          "accepting_payment_cards": "Prihvaćanje platnih kartica",
          "wifi": "Wifi",
          "pool": "Bazen",
          "kitchen": "Kuhinja",
          "washing_machine": "Perilica za rublje",
          "drying_machine": "Sušilica za rublje",
          "edit_presentation": "Uredi prezentaciju",
          "delete_estate": "Izbriši nekretninu",
          "delete_estate_warning_message":
              "Jeste li sigurni da želite izbrisati svoju nekretninu?",
          "cancel": "Otkaži",
          "choose_file": "Odaberite datoteku",
          "no_file": "Nema datoteke",
          "cannot_preview": "Nije moguće pregledati",
          "save_image": "Spremiti sliku",
          "banned_by_admin":
              "Administrator je izbrisao vaš korisnički račun. Za više informacija možete kontaktirati admina na admin@diplomski.com.",
          "blocked_by_admin":
              "Vaš korisnički račun je trenutno blokiran od strane administratora. Za više informacija možete kontaktirati admina na admin@diplomski.com.",
          "cant_log_in":
              "There was an error while logging in. Please try again (later)...",
          "successful_login": "You have successfully logged in!",
          "old_password": "Stara lozinka",
          "new_password": "Nova lozinka",
          "repeat_password": "Ponovite lozinku",
          "type_of_customer": "Vrsta korisnika",
          "password": "Lozinka",
          "delete_account_warning_message":
              "Jeste li sigurni da želite izbrisati svoj račun? Vaši će podaci biti trajno izgubljeni!",
          "customers": "Korisnici",
          "sign_up": "Prijavite se",
          "have_account_login_here": "Već imate račun? Prijavite se ovdje.",
          "cant_register":
              "Došlo je do problema prilikom pokušaja kreiranja vašeg računa. Pokušajte ponovno kasnije.",
          "account_successfully_created":
              "Vaš račun za plin uspješno je kreiran!",
          "keep_me_logged_in": "Zadrži me prijavljenim.",
          "dont_have_account_register_here":
              "Nemate račun? Prijavite se ovdje.",
          "sign_in": "Prijava",
          "sign_in_with_google": "Prijavite se s Googleom",
          "sign_in_with_facebook": "Prijavite se putem Facebooka",
          "avatar_image": "Profilna slika",
          "or": "ili",
          "email": "Email",
          "show": "Prikaži",
          "dont_show": "Nemoj prikazati",
        };

        /*if (specific != null && specific.isNotEmpty) {
          if (jsonHR[specific] != null) {
            return {specific: jsonHR[specific]} as Map<String, String>;
          }
          return {specific: ""};
        }*/
        return jsonHR as Map<String, String>;
    }
    return {};
  }
}