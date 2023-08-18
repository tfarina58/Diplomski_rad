enum Direction { west, north, east, south }

enum EstateType { west, north, east, south }

class EstatePreferences {
  bool? petsAllowed;
  bool? smokingAllowed;
  bool? airConditioning;
  bool? handicapAccessible;
  int? designatedParkingSpots;
  String? outletType;
  Direction? houseOrientation;
  bool? acceptingPaymentCards;
  bool? wifi;
  bool? pool;
  bool? kitchen;
  bool? washingMachine;
  bool? dryingMachine;

  EstatePreferences({
    this.petsAllowed = false,
    this.smokingAllowed = false,
    this.airConditioning = false,
    this.handicapAccessible = false,
    this.designatedParkingSpots = 0,
    this.outletType,
    this.houseOrientation,
    this.acceptingPaymentCards,
    this.wifi,
    this.pool,
    this.kitchen,
    this.washingMachine,
    this.dryingMachine,
  });

  /*
    Icon(Icons.build),
    Icon(Icons.close),
    Icon(Icons.pets),
    Icon(Icons.smoke_free),
    Icon(Icons.smoking_rooms),
    */
}
