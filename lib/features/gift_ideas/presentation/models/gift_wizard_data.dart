class GiftWizardData {
  String? name;
  String gender = 'X';
  int? age;
  String? relation;
  List<String> interests;
  String? category;
  int? minPrice;
  int? maxPrice;
  
  GiftWizardData({
    this.name,
    this.gender = 'X',
    this.age,
    this.relation,
    this.interests = const [],
    this.category,
    this.minPrice,
    this.maxPrice,
  });

  bool get isStepOneComplete => age != null;
  bool get isStepTwoComplete => gender != null && gender.isNotEmpty;
  bool get isStepThreeComplete => relation != null && relation!.isNotEmpty;
  bool get isStepFourComplete => interests.isNotEmpty;
  bool get isStepFiveComplete => category != null && category!.isNotEmpty;
  bool get isPriceComplete => minPrice != null && maxPrice != null;
  
  bool get isComplete => 
      isStepOneComplete && 
      isStepTwoComplete && 
      isStepThreeComplete && 
      isStepFourComplete &&
      isStepFiveComplete &&
      isPriceComplete;
      
  Map<String, dynamic> toJson() {
    return {
      'name': name ?? '',
      'age': age?.toString() ?? '',
      'gender': gender,
      'relation': relation ?? '',
      'interests': interests,
      'category': category ?? '',
      'min_price': minPrice,
      'max_price': maxPrice
    };
  }
}