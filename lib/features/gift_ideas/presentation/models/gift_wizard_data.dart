class GiftWizardData {
  String? name;
  String gender = 'X';
  int? age;
  String? relation;
  List<String> interests;
  String? category;
  String? budget;
  
  GiftWizardData({
    this.name,
    this.gender = 'X',
    this.age,
    this.relation,
    this.interests = const [],
    this.category,
    this.budget,
  });

  bool get isStepOneComplete => age != null;
  bool get isStepTwoComplete => gender != null && gender.isNotEmpty;
  bool get isStepThreeComplete => relation != null && relation!.isNotEmpty;
  bool get isStepFourComplete => interests.isNotEmpty;
  bool get isStepFiveComplete => category != null && category!.isNotEmpty;
  bool get isBudgetComplete => budget != null && budget!.isNotEmpty;
  
  bool get isComplete => 
      isStepOneComplete && 
      isStepTwoComplete && 
      isStepThreeComplete && 
      isStepFourComplete &&
      isStepFiveComplete &&
      isBudgetComplete;
      
  Map<String, dynamic> toJson() {
    return {
      'name': name ?? '',
      'age': age?.toString() ?? '',
      'gender': gender,
      'relation': relation ?? '',
      'interests': interests,
      'category': category ?? '',
      'budget': budget ?? ''
    };
  }
}