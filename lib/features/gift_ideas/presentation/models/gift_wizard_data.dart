class GiftWizardData {
  String? name;
  String? age;
  String? relation;
  List<String> interests;
  String? category;
  String? budget;
  
  GiftWizardData({
    this.name,
    this.age,
    this.relation,
    List<String>? interests,
    this.category,
    this.budget,
  }) : interests = interests ?? [];

  bool get isStepOneComplete => age != null && age!.isNotEmpty;
  bool get isStepTwoComplete => relation != null && relation!.isNotEmpty;
  bool get isStepThreeComplete => interests.isNotEmpty;
  bool get isStepFourComplete => category != null && category!.isNotEmpty;
  bool get isStepFiveComplete => budget != null && budget!.isNotEmpty;
  
  bool get isComplete => 
      isStepOneComplete && 
      isStepTwoComplete && 
      isStepThreeComplete && 
      isStepFourComplete &&
      isStepFiveComplete;
}