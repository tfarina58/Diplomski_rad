class EstatePreferences {
  bool petsAllowed;
  bool smokingAllowed;
  bool airConditioning;
  bool handicapAccessible;
  String designatedParkingSpots;
  String outletType;
  String houseOrientation;
  bool acceptingPaymentCards;
  bool wifi;
  bool pool;
  bool kitchen;
  bool washingMachine;
  bool dryingMachine;

  EstatePreferences({
    this.petsAllowed = false,
    this.smokingAllowed = false,
    this.airConditioning = false,
    this.handicapAccessible = false,
    this.designatedParkingSpots = '0',
    this.outletType = "C",
    this.houseOrientation = "N",
    this.acceptingPaymentCards = false,
    this.wifi = false,
    this.pool = false,
    this.kitchen = false,
    this.washingMachine = false,
    this.dryingMachine = false,
  });

  /*
    Icon(Icons.build),
    Icon(Icons.close),
    Icon(Icons.pets),
    Icon(Icons.smoke_free),
    Icon(Icons.smoking_rooms),
    */
}
