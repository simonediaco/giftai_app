class GiftWizardData {
  String? name;
  String gender = 'X';
  DateTime? birthDate;
  String? relation;
  List<String> interests;
  String? category;
  String? budget;
  
  GiftWizardData({
    this.name,
    this.gender = 'X',
    this.birthDate,
    this.relation,
    this.interests = const [],
    this.category,
    this.budget,
  });

  bool get isStepOneComplete => birthDate != null;
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