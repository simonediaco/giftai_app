class Gift {
  final int? id;
  final String name;
  final double price;
  final int match;
  final String? image;
  final String category;
  final String? description;
  final String? notes;
  final int? recipientId;

  Gift({
    this.id,
    required this.name,
    required this.price,
    required this.match,
    this.image,
    required this.category,
    this.description,
    this.notes,
    this.recipientId,
  });

  /// Crea un Gift da un JSON
  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
      id: json['id'],
      name: json['name'],
      price: (json['price'] is int) ? (json['price'] as int).toDouble() : json['price'],
      match: json['match'],
      image: json['image'],
      category: json['category'],
      description: json['description'],
      notes: json['notes'],
      recipientId: json['recipient'],
    );
  }

  /// Converte il regalo in JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'price': price,
      'match': match,
      'category': category,
      'description': description,
      'notes': notes,
    };

    if (id != null) data['id'] = id;
    if (image != null) data['image'] = image;
    if (description != null) data['description'] = description;
    if (notes != null) data['notes'] = notes;
    if (recipientId != null) data['recipient'] = recipientId;

    return data;
  }

  /// Crea una copia del regalo con valori aggiornati
  Gift copyWith({
    int? id,
    String? name,
    double? price,
    int? match,
    String? image,
    String? category,
    String? description,
    String? notes,
    int? recipientId,
  }) {
    return Gift(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      match: match ?? this.match,
      image: image ?? this.image,
      category: category ?? this.category,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      recipientId: recipientId ?? this.recipientId,
    );
  }

  /// Formatta il prezzo con il simbolo € e 2 decimali
  String get formattedPrice {
    return '${price.toStringAsFixed(2)}€';
  }

  /// Ottiene l'URL completo dell'immagine (se presente)
  String? getFullImageUrl(String baseUrl) {
    if (image == null) return null;
    if (image!.startsWith('http')) return image;
    return '$baseUrl$image';
  }
  
  /// Verifica se l'immagine inizia con un pattern specifico (gestendo null)
  bool imageStartsWith(Pattern pattern) {
    return image != null && image!.startsWith(pattern);
  }

  @override
  String toString() {
    return 'Gift(id: $id, name: $name, price: $price, match: $match, category: $category)';
  }

  String getAmazonUrl() {
    // TODO: Implement logic to generate the Amazon URL for this gift.
    // For now, throw UnimplementedError to satisfy the non-nullable return type.
    throw UnimplementedError('getAmazonUrl() has not been implemented.');
  }
}