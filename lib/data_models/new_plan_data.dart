class NewPlanData {
  final String source, destination;
  final double totalDistance,
      totalRideHotelExpense,
      totalRideFoodExpense,
      vehicleMileage,
      totalRideFuelRequired,
      totalRideFuelCost,
      totalRideExpense;
  final int totalNoOfDays;

  NewPlanData(
      {this.source,
      this.destination,
      this.totalDistance,
      this.totalNoOfDays,
      this.totalRideHotelExpense,
      this.totalRideFoodExpense,
      this.vehicleMileage,
      this.totalRideFuelRequired,
      this.totalRideFuelCost,
      this.totalRideExpense});

  Map<String, dynamic> toMap() {
    return {
      "source": source,
      "destination": destination,
      "totalDistance": totalDistance,
      "totalNoOfDays": totalNoOfDays,
      "totalRideHotelExpense": totalRideHotelExpense,
      "totalRideFoodExpense": totalRideFoodExpense,
      "vehicleMileage": vehicleMileage,
      "totalRideFuelRequired": totalRideFuelRequired,
      "totalRideFuelCost": totalRideFuelCost,
      "totalRideExpense": totalRideExpense,
    };
  }
}
