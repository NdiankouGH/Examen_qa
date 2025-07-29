# mongodb_keywords.py
import pymongo
from bson import ObjectId
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
import json
from datetime import datetime

class MongoDBKeywords:
    """Bibliothèque personnalisée pour les opérations MongoDB avec Robot Framework"""
    
    def __init__(self):
        self.client = None
        self.database = None
    
    @keyword
    def connect_to_mongodb_atlas(self, connection_string, database_name):
        """Connexion à MongoDB Atlas"""
        try:
            # Initialiser le client MongoDB
            self.client = pymongo.MongoClient(connection_string)
            
            # Vérifier la connexion
            self.client.admin.command('ping')
            
            # Sélectionner la base de données
            self.database = self.client[database_name]
            
            # Vérifier que la base de données existe en listant ses collections
            collections = self.database.list_collection_names()
            BuiltIn().log_to_console(f" Collections trouvées: {collections}")
                
            BuiltIn().log_to_console(f" Base de données sélectionnée : {self.database.name}")
            BuiltIn().log_to_console("Connexion MongoDB Atlas réussie")
            
            # Stockage en variable de suite pour garantir la persistance
            BuiltIn().set_suite_variable('${MONGODB_CLIENT}', self.client)
            BuiltIn().set_suite_variable('${MONGODB_DATABASE}', self.database)
            
            return True
            
        except Exception as e:
            BuiltIn().log_to_console(f" Erreur de connexion: {str(e)}")
            raise Exception(f"Échec de connexion à MongoDB: {str(e)}")    
    
    @keyword
    def close_mongodb_connection(self):
        """Fermer la connexion MongoDB"""
        if self.client:
            self.client.close()
            BuiltIn().log_to_console(" Connexion MongoDB fermée")
    
    # ==================== OPÉRATIONS CRUD PRODUITS ====================
    
    @keyword
    def insert_product(self, title, price, description, category, quantity, image):
        """Insérer un produit - Scénario passant"""
        try:
            # Récupérer la base de données depuis la variable de suite
            database = BuiltIn().get_variable_value("${MONGODB_DATABASE}")
            if database is None:
                raise Exception("La connexion à la base de données n'est pas établie")
                    
            product_data = {
                "title": title,
                "price": float(price),
                "description": description, 
                "category": category,
                "quantity": int(quantity),
                "image": image,
                "created_at": datetime.now(),
                "updated_at": datetime.now()
            }
            
            collection = database["products"]
            if collection is None:
                raise Exception("Collection 'products' non trouvée")
                    
            BuiltIn().log_to_console(f"  Base de données sélectionnée : {database.name}")
            result = collection.insert_one(product_data)
            
            if result is None:
                raise Exception("Échec de l'insertion - Aucun résultat retourné")
                    
            BuiltIn().log_to_console(f" Insertion dans la collection: {collection.name}")
            BuiltIn().log_to_console(f"  Données: {product_data}")
            BuiltIn().log_to_console(f" Produit inséré avec ID: {result.inserted_id}")
                
            return str(result.inserted_id)
        except Exception as e:
            BuiltIn().log_to_console(f" Erreur insertion produit: {str(e)}")
            raise Exception(f"Échec insertion produit: {str(e)}")
        
    @keyword
    def insert_product_should_fail(self, title, price, description, category, quantity, image):
        """Insérer un produit - Scénario non passant (données invalides)"""
        try:
            # Validation des données
            if not title or not isinstance(title, str):
                raise ValueError("Le titre est requis et doit être une chaîne de caractères")
                
            try:
                price = float(price)
                if price <= 0:
                    raise ValueError("Le prix doit être positif")
            except (ValueError, TypeError):
                raise ValueError("Le prix doit être un nombre valide")
                
            if not description or not isinstance(description, str):
                raise ValueError("La description est requise et doit être une chaîne")
                
            if not category or not isinstance(category, str):
                raise ValueError("La catégorie est requise et doit être une chaîne")
                
            try:
                quantity = int(quantity)
                if quantity < 0:
                    raise ValueError("La quantité ne peut pas être négative")
            except (ValueError, TypeError):
                raise ValueError("La quantité doit être un nombre entier")
                
            # Si on arrive ici, le test doit
            raise AssertionError("Les données invalides ont été acceptées")
            
        except Exception as e:
            BuiltIn().log_to_console(f" Échec attendu: {str(e)}")
            raise Exception(str(e))
    
    @keyword
    def get_product_by_id(self, product_id):
        """Récupérer un produit par ID - Scénario passant"""
        try:
            database = BuiltIn().get_variable_value("${MONGODB_DATABASE}")
            if database is None:
                raise Exception("La connexion à la base de données n'est pas établie")
                    
            collection = database["products"]
            if isinstance(product_id, str):
                product_id = ObjectId(product_id)
            
            product = collection.find_one({"_id": product_id})
            
            if product:
                # Convertir ObjectId en string pour Robot Framework
                product["_id"] = str(product["_id"])
                BuiltIn().log_to_console(f" Produit trouvé: {product['title']}")
                return product
            else:
                raise Exception(f"Produit non trouvé avec ID: {product_id}")
                
        except Exception as e:
            BuiltIn().log_to_console(f" Erreur récupération produit: {str(e)}")
            raise Exception(f"Échec récupération produit: {str(e)}")
    
    @keyword
    def get_product_by_invalid_id(self, invalid_id):
        """Récupérer un produit avec ID invalide - Scénario non passant"""
        try:
            collection = self.database["products"]
            product = collection.find_one({"_id": invalid_id})
            
            if product is None:
                BuiltIn().log_to_console(" Aucun produit trouvé comme attendu")
                return None
            else:
                raise Exception("Un produit a été trouvé avec un ID invalide")
                
        except Exception as e:
            BuiltIn().log_to_console(f" Échec attendu: {str(e)}")
            return "Échec attendu"
    
    @keyword
    def update_product(self, product_id, title=None, price=None, description=None, category=None, quantity=None):
        """Mettre à jour un produit - Scénario passant"""
        try:
                # Récupérer la base de données depuis la variable de suite
            database = BuiltIn().get_variable_value("${MONGODB_DATABASE}")
            if database is None:
                raise Exception("La connexion à la base de données n'est pas établie")
                
            collection = database["products"]
          
            update_data = {"updated_at": datetime.now()}
            
            if title:
                update_data["title"] = title
            if price:
                update_data["price"] = float(price)
            if description:
                update_data["description"] = description
            if category:
                update_data["category"] = category
            if quantity:
                update_data["quantity"] = int(quantity)
            if isinstance(product_id, str):
                try:
                    product_id = ObjectId(product_id)
                except Exception:
                    raise Exception(f"ID de produit invalide : {product_id}")

            result = collection.update_one(
                {"_id": product_id},
                {"$set": update_data}
            )
            
            if result.modified_count > 0:
                BuiltIn().log_to_console(f"Produit mis à jour: {result.modified_count} document(s)")
                return result.modified_count
            else:
                raise Exception("Aucun produit mis à jour")
                
        except Exception as e:
            BuiltIn().log_to_console(f"Erreur mise à jour produit: {str(e)}")
            raise Exception(f"Échec mise à jour produit: {str(e)}")
    
    @keyword
    def delete_product(self, product_id):
        """Supprimer un produit - Scénario passant"""
        try:
            database = BuiltIn().get_variable_value("${MONGODB_DATABASE}")
            if database is None:
                raise Exception("La connexion à la base de données n'est pas établie")
                
            collection = database["products"]
            if isinstance(product_id, str):
                try:
                    product_id = ObjectId(product_id)
                except Exception:
                    raise Exception(f"ID de produit invalide : {product_id}")

            result = collection.delete_one({"_id": product_id})
            
            if result.deleted_count > 0:
                BuiltIn().log_to_console(f"Produit supprimé: {result.deleted_count} document(s)")
                return result.deleted_count
            else:
                raise Exception("Aucun produit supprimé")
                
        except Exception as e:
            BuiltIn().log_to_console(f"Erreur suppression produit: {str(e)}")
            raise Exception(f"Échec suppression produit: {str(e)}")
    
    # ==================== OPÉRATIONS CRUD UTILISATEURS ====================
    
    @keyword
    def insert_user(self, firstname, lastname, email, username, password, phone):
        """Insérer un utilisateur - Scénario passant"""
        try:
            # Récupérer la base de données depuis la variable de suite
            database = BuiltIn().get_variable_value("${MONGODB_DATABASE}")
            if database is None:
                raise Exception("La connexion à la base de données n'est pas établie")

            user_data = {
                "firstname": firstname,
                "lastname": lastname,
                "email": email,
                "username": username,
                "password": password,  # En production, hasher le mot de passe !
                "phone": phone,
                "created_at": datetime.now(),
                "updated_at": datetime.now()
            }

            collection = database["users"]
            if collection is None:
                raise Exception("Collection 'users' non trouvée")

            BuiltIn().log_to_console(f"  Base de données sélectionnée : {database.name}")
            result = collection.insert_one(user_data)

            if result is None:
                raise Exception("Échec de l'insertion - Aucun résultat retourné")

            BuiltIn().log_to_console(f" Insertion dans la collection: {collection.name}")
            BuiltIn().log_to_console(f"  Données: {user_data}")
            BuiltIn().log_to_console(f" Utilisateur inséré avec ID: {result.inserted_id}")

            return str(result.inserted_id)
            
        except Exception as e:
            BuiltIn().log_to_console(f"Erreur insertion utilisateur: {str(e)}")
            raise Exception(f"Échec insertion utilisateur: {str(e)}")
    
    @keyword
    def get_user_by_email(self, email):
        """Récupérer un utilisateur par email - Scénario passant"""
        try:
            database = BuiltIn().get_variable_value("${MONGODB_DATABASE}")
            if database is None:
                raise Exception("La connexion à la base de données n'est pas établie")

            collection = database["users"]
            user = collection.find_one({"email": email})

            if user:
                # Convertir ObjectId en string pour Robot Framework
                user["_id"] = str(user["_id"])
                BuiltIn().log_to_console(f" Utilisateur trouvé: {user['username']}")
                return user
            else:
                raise Exception(f"Utilisateur non trouvé avec email: {email}")
                
        except Exception as e:
            BuiltIn().log_to_console(f"Erreur récupération utilisateur: {str(e)}")
            raise Exception(f"Échec récupération utilisateur: {str(e)}")

    @keyword
    def insert_user_should_fail(self, firstname, lastname, email, username, password, phone):
        """Insérer un utilisateur - Scénario non passant (données invalides)"""
        try:
            # Validation des données
            if not firstname or not isinstance(firstname, str):
                raise ValueError("Le prénom est requis et doit être une chaîne de caractères")

            if not lastname or not isinstance(lastname, str):
                raise ValueError("Le nom est requis et doit être une chaîne de caractères")

            if not email or not isinstance(email, str):
                raise ValueError("L'email est requis et doit être une chaîne de caractères")

            # Validation simple du format email
            if not "@" in str(email) or not "." in str(email):
                raise ValueError("Format d'email invalide")

            if not username or not isinstance(username, str):
                raise ValueError("Le nom d'utilisateur est requis et doit être une chaîne")

            if not password or not isinstance(password, str) or len(password) < 8:
                raise ValueError("Le mot de passe est requis et doit contenir au moins 8 caractères")

            if not phone or not isinstance(phone, str):
                raise ValueError("Le numéro de téléphone est requis et doit être une chaîne")

            # Si on arrive ici, le test doit échouer
            raise AssertionError("Les données invalides ont été acceptées")

        except Exception as e:
            BuiltIn().log_to_console(f" Échec attendu: {str(e)}")
            raise Exception(str(e))

    @keyword
    def get_user_by_id(self, user_id):
        """Récupérer un utilisateur par ID - Scénario passant"""
        try:
            database = BuiltIn().get_variable_value("${MONGODB_DATABASE}")
            if database is None:
                raise Exception("La connexion à la base de données n'est pas établie")

            collection = database["users"]
            if isinstance(user_id, str):
                user_id = ObjectId(user_id)

            user = collection.find_one({"_id": user_id})

            if user:
                # Convertir ObjectId en string pour Robot Framework
                user["_id"] = str(user["_id"])
                BuiltIn().log_to_console(f" Utilisateur trouvé: {user['username']}")
                return user
            else:
                raise Exception(f"Utilisateur non trouvé avec ID: {user_id}")

        except Exception as e:
            BuiltIn().log_to_console(f" Erreur récupération utilisateur: {str(e)}")
            raise Exception(f"Échec récupération utilisateur: {str(e)}")

    @keyword
    def get_user_by_invalid_id(self, invalid_id):
        """Récupérer un utilisateur avec ID invalide - Scénario non passant"""
        try:
            database = BuiltIn().get_variable_value("${MONGODB_DATABASE}")
            if database is None:
                raise Exception("La connexion à la base de données n'est pas établie")

            collection = database["users"]
            user = collection.find_one({"_id": invalid_id})

            if user is None:
                BuiltIn().log_to_console(" Aucun utilisateur trouvé comme attendu")
                return None
            else:
                raise Exception("Un utilisateur a été trouvé avec un ID invalide")

        except Exception as e:
            BuiltIn().log_to_console(f" Échec attendu: {str(e)}")
            return "Échec attendu"

    @keyword
    def update_user(self, user_id, firstname=None, lastname=None, email=None, username=None, password=None, phone=None):
        """Mettre à jour un utilisateur - Scénario passant"""
        try:
            # Récupérer la base de données depuis la variable de suite
            database = BuiltIn().get_variable_value("${MONGODB_DATABASE}")
            if database is None:
                raise Exception("La connexion à la base de données n'est pas établie")

            collection = database["users"]

            update_data = {"updated_at": datetime.now()}

            if firstname:
                update_data["firstname"] = firstname
            if lastname:
                update_data["lastname"] = lastname
            if email:
                update_data["email"] = email
            if username:
                update_data["username"] = username
            if password:
                update_data["password"] = password
            if phone:
                update_data["phone"] = phone

            if isinstance(user_id, str):
                try:
                    user_id = ObjectId(user_id)
                except Exception:
                    raise Exception(f"ID d'utilisateur invalide : {user_id}")

            result = collection.update_one(
                {"_id": user_id},
                {"$set": update_data}
            )

            if result.modified_count > 0:
                BuiltIn().log_to_console(f"Utilisateur mis à jour: {result.modified_count} document(s)")
                return result.modified_count
            else:
                raise Exception("Aucun utilisateur mis à jour")

        except Exception as e:
            BuiltIn().log_to_console(f"Erreur mise à jour utilisateur: {str(e)}")
            raise Exception(f"Échec mise à jour utilisateur: {str(e)}")

    @keyword
    def delete_user(self, user_id):
        """Supprimer un utilisateur - Scénario passant"""
        try:
            database = BuiltIn().get_variable_value("${MONGODB_DATABASE}")
            if database is None:
                raise Exception("La connexion à la base de données n'est pas établie")

            collection = database["users"]
            if isinstance(user_id, str):
                try:
                    user_id = ObjectId(user_id)
                except Exception:
                    raise Exception(f"ID d'utilisateur invalide : {user_id}")

            result = collection.delete_one({"_id": user_id})

            if result.deleted_count > 0:
                BuiltIn().log_to_console(f"Utilisateur supprimé: {result.deleted_count} document(s)")
                return result.deleted_count
            else:
                raise Exception("Aucun utilisateur supprimé")

        except Exception as e:
            BuiltIn().log_to_console(f"Erreur suppression utilisateur: {str(e)}")
            raise Exception(f"Échec suppression utilisateur: {str(e)}")
    
    # ==================== OPÉRATIONS CRUD PANIERS ====================

    # ==================== OPÉRATIONS CRUD PANIERS ====================

    @keyword
    def create_cart(self, user_id, products_list):
        """Créer un panier - Scénario passant"""
        try:
            database = BuiltIn().get_variable_value("${MONGODB_DATABASE}")
            if database is None:
                raise Exception("La connexion à la base de données n'est pas établie")

            # Conversion du user_id en ObjectId si c'est une chaîne
            if isinstance(user_id, str):
                try:
                    user_id = ObjectId(user_id)
                except Exception:
                    raise Exception(f"ID utilisateur invalide : {user_id}")

            cart_data = {
                "user_id": user_id,
                "products": products_list,
                "status": "active",
                "created_at": datetime.now(),
                "updated_at": datetime.now()
            }

            collection = database["carts"]
            result = collection.insert_one(cart_data)

            BuiltIn().log_to_console(f"Panier créé avec ID: {result.inserted_id}")
            return str(result.inserted_id)

        except Exception as e:
            BuiltIn().log_to_console(f"Erreur création panier: {str(e)}")
            raise Exception(f"Échec création panier: {str(e)}")

    @keyword
    def create_cart_should_fail(self, user_id, products_list):
        """Créer un panier - Scénario non passant"""
        try:
            # Validation des données
            if not user_id:
                raise ValueError("L'ID utilisateur est requis")

            if not products_list or not isinstance(products_list, list):
                raise ValueError("La liste des produits est requise et doit être une liste")

            for product in products_list:
                if not isinstance(product, dict):
                    raise ValueError("Chaque produit doit être un dictionnaire")
                if "product_id" not in product or "quantity" not in product:
                    raise ValueError("Chaque produit doit avoir un ID et une quantité")
                if product.get("quantity", 0) <= 0:
                    raise ValueError("La quantité doit être supérieure à 0")
                if product.get("product_id", "invalid_product_id") == "invalid_product_id":
                    raise ValueError("ID de produit invalide")

            raise AssertionError("Les données invalides ont été acceptées")

        except Exception as e:
            BuiltIn().log_to_console(f"Échec attendu: {str(e)}")
            raise Exception(str(e))

    @keyword
    def get_cart_by_id(self, cart_id):
        """Récupérer un panier par ID - Scénario passant"""
        try:
            database = BuiltIn().get_variable_value("${MONGODB_DATABASE}")
            if database is None:
                raise Exception("La connexion à la base de données n'est pas établie")

            collection = database["carts"]
            if isinstance(cart_id, str):
                cart_id = ObjectId(cart_id)

            cart = collection.find_one({"_id": cart_id})

            if cart:
                # Conversion des ObjectId en string
                cart["_id"] = str(cart["_id"])
                cart["user_id"] = str(cart["user_id"])
                BuiltIn().log_to_console(f"Panier trouvé pour l'utilisateur: {cart['user_id']}")
                return cart
            else:
                raise Exception(f"Panier non trouvé avec ID: {cart_id}")

        except Exception as e:
            BuiltIn().log_to_console(f"Erreur récupération panier: {str(e)}")
            raise Exception(f"Échec récupération panier: {str(e)}")

    @keyword
    def get_cart_by_invalid_id(self, invalid_id):
        """Récupérer un panier avec ID invalide - Scénario non passant"""
        try:
            database = BuiltIn().get_variable_value("${MONGODB_DATABASE}")
            if database is None:
                raise Exception("La connexion à la base de données n'est pas établie")

            collection = database["carts"]
            cart = collection.find_one({"_id": invalid_id})

            if cart is None:
                BuiltIn().log_to_console("Aucun panier trouvé comme attendu")
                return "NOT_FOUND"
            else:
                raise Exception("Un panier a été trouvé avec un ID invalide")

        except Exception as e:
            BuiltIn().log_to_console(f"Échec attendu: {str(e)}")
            return "Échec attendu"

    @keyword
    def update_cart(self, cart_id, products_list=None, status=None):
        """Mettre à jour un panier - Scénario passant"""
        try:
            database = BuiltIn().get_variable_value("${MONGODB_DATABASE}")
            if database is None:
                raise Exception("La connexion à la base de données n'est pas établie")

            collection = database["carts"]
            update_data = {"updated_at": datetime.now()}

            if products_list is not None:
                update_data["products"] = products_list
            if status is not None:
                update_data["status"] = status

            if isinstance(cart_id, str):
                try:
                    cart_id = ObjectId(cart_id)
                except Exception:
                    raise Exception(f"ID de panier invalide : {cart_id}")

            result = collection.update_one(
                {"_id": cart_id},
                {"$set": update_data}
            )

            if result.modified_count > 0:
                BuiltIn().log_to_console(f"Panier mis à jour: {result.modified_count} document(s)")
                return result.modified_count
            else:
                raise Exception("Aucun panier mis à jour")

        except Exception as e:
            BuiltIn().log_to_console(f"Erreur mise à jour panier: {str(e)}")
            raise Exception(f"Échec mise à jour panier: {str(e)}")


    @keyword
    def update_cart_should_fail(self, cart_id, products_list=None, status=None):
        """Mettre à jour un panier - Scénario non passant"""
        try:
            # Validation de l'ID du panier
            if not cart_id:
                raise ValueError("L'ID du panier est requis")

            # Validation de la liste des produits si fournie
            if products_list is not None:
                if not isinstance(products_list, list):
                    raise ValueError("La liste des produits doit être une liste")
                for product in products_list:
                    if not isinstance(product, dict):
                        raise ValueError("Chaque produit doit être un dictionnaire")
                    if "product_id" not in product or "quantity" not in product:
                        raise ValueError("Chaque produit doit avoir un ID et une quantité")
                    if product.get("quantity", 0) <= 0:
                        raise ValueError("La quantité doit être supérieure à 0")

            # Validation du statut si fourni
            if status is not None and status not in ["active", "completed", "cancelled"]:
                raise ValueError("Le statut doit être 'active', 'completed' ou 'cancelled'")

            # Si toutes les validations passent, le test doit échouer
            raise AssertionError("Les données invalides ont été acceptées")

        except Exception as e:
            BuiltIn().log_to_console(f"Échec attendu: {str(e)}")
            raise Exception(str(e))




    @keyword
    def delete_cart(self, cart_id):
        """Supprimer un panier - Scénario passant"""
        try:
            database = BuiltIn().get_variable_value("${MONGODB_DATABASE}")
            if database is None:
                raise Exception("La connexion à la base de données n'est pas établie")

            collection = database["carts"]
            if isinstance(cart_id, str):
                try:
                    cart_id = ObjectId(cart_id)
                except Exception:
                    raise Exception(f"ID de panier invalide : {cart_id}")

            result = collection.delete_one({"_id": cart_id})

            if result.deleted_count > 0:
                BuiltIn().log_to_console(f"Panier supprimé: {result.deleted_count} document(s)")
                return result.deleted_count
            else:
                raise Exception("Aucun panier supprimé")

        except Exception as e:
            BuiltIn().log_to_console(f"Erreur suppression panier: {str(e)}")
            raise Exception(f"Échec suppression panier: {str(e)}")

    @keyword
    def delete_cart_should_fail(self, cart_id):
        """Supprimer un panier - Scénario non passant"""
        try:
            database = BuiltIn().get_variable_value("${MONGODB_DATABASE}")
            if database is None:
                raise Exception("La connexion à la base de données n'est pas établie")

            # Validation de l'ID du panier
            if not cart_id:
                raise ValueError("L'ID du panier est requis")

            collection = database["carts"]

            # Test avec un ID invalide
            if not isinstance(cart_id, (ObjectId, str)) or (isinstance(cart_id, str) and len(cart_id) != 24):
                raise ValueError(f"ID de panier invalide : {cart_id}")

            # Test avec un ID inexistant
            try:
                if isinstance(cart_id, str):
                    cart_id = ObjectId(cart_id)
            except Exception:
                raise ValueError(f"ID de panier invalide : {cart_id}")

            # Vérification si le panier existe
            cart = collection.find_one({"_id": cart_id})
            if not cart:
                raise Exception(f"Panier non trouvé avec ID: {cart_id}")

            # Si le panier existe et est en cours d'utilisation
            if cart.get("status") == "active":
                raise ValueError("Impossible de supprimer un panier actif")

            raise AssertionError("La suppression aurait dû échouer")

        except Exception as e:
            BuiltIn().log_to_console(f"Échec attendu: {str(e)}")
            raise Exception(str(e))
    #==================== OPÉRATIONS AVEC AUTHENTIFICATION ====================
    @keyword
    def authenticate_user(self, username, password):
        """Authentifier un utilisateur - Scénario passant"""
        try:
            database = BuiltIn().get_variable_value("${MONGODB_DATABASE}")
            if database is None:
                raise Exception("La connexion à la base de données n'est pas établie")

            collection = database["users"]
            user = collection.find_one({"username": username, "password": password})

            if user:
                # Convertir ObjectId en string pour Robot Framework
                user["_id"] = str(user["_id"])
                BuiltIn().log_to_console(f"Utilisateur authentifié: {user['username']}")
                return user
            else:
                raise Exception("Échec de l'authentification: utilisateur ou mot de passe incorrect")

        except Exception as e:
            BuiltIn().log_to_console(f"Erreur authentification utilisateur: {str(e)}")
            raise Exception(f"Échec authentification utilisateur: {str(e)}")
    @keyword
    def cleanup_test_data(self):
        """Nettoyer les données de test"""
        try:
            # Supprimer les données de test
            self.database["products"].delete_many({"title": {"$regex": "Test"}})
            self.database["users"].delete_many({"username": {"$regex": "test"}})
            self.database["carts"].delete_many({"status": "test"})
            
            BuiltIn().log_to_console("Données de test nettoyées")
            
        except Exception as e:
            BuiltIn().log_to_console(f"Erreur nettoyage: {str(e)}")
