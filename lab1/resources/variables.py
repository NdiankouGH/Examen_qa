# resources/variables.py

MONGO_URI = "mongodb+srv://ndiankou12345:LAlKYqkELp5HNw7r@cluster0.hddhf8c.mongodb.net/fakeStoredb?retryWrites=true&w=majority&appName=Cluster0"
DB_NAME = "fakeStoredb"
PRODUCTS_COLLECTION = "products"
USERS_COLLECTION = "users"
CARTS_COLLECTION = "carts" 

TEST_TIMEOUT = 30   # Timeout en secondes pour les tests
MAX_RETRIES = 3     # Nombre maximum de tentatives en cas d'échec

# Données de test par défaut
DEFAULT_PRODUCT_DATA = {
    "title": "Sample Product",
    "price": 1900.99,
    "description": "A sample product for testing",
    "category": "electronics",
    "quantity": 10,
    "image": "https://via.placeholder.com/300x300"
}

DEFAULT_USER_DATA = {
    "firstname": "Test",
    "lastname": "User",
    "email": "test.user@example.com",
    "username": "testuser",
    "password": "testpassword123",
    "phone": "+221771234567"
}

# Vous aurez besoin de données pour les scénarios non passants aussi
INVALID_PRODUCT_DATA_MISSING_FIELD = {
    "title": "Invalid Product",
    "price": "not_a_number", # Donnée invalide
    "description": "Missing category",
    "image": "https://via.placeholder.com/300x300"
}

INVALID_USER_DATA_DUPLICATE_EMAIL = {
    "firstname": "Duplicate",
    "lastname": "User",
    "email": 124, #"test.user@example.com, # Email dupliqué pour test négatif
    "username": "duplicateuser",
    "password": "dup_password",
    "phone": "+221779999999"
}

# Configuration des collections
COLLECTIONS = {
    "products": PRODUCTS_COLLECTION,
    "users": USERS_COLLECTION,
    "carts": CARTS_COLLECTION
}



# Messages d'erreur personnalisés
ERROR_MESSAGES = {
    "connection_failed": "Échec de connexion à MongoDB Atlas",
    "invalid_product_id": "ID de produit invalide",
    "product_not_found": "Produit non trouvé",
    "invalid_user_data": "Données utilisateur invalides",
    "user_not_found": "Utilisateur non trouvé",
    "cart_creation_failed": "Échec de création du panier",
    "duplicate_email": "Un utilisateur avec cet email existe déjà" # Nouveau message pour test négatif
}
INVALID_EMAIL = ""
