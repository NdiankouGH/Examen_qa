*** Variables ***
# Variables pour les tests de produits
${VALID_PRODUCT_TITLE}        Test Product Robot Framework
${VALID_PRODUCT_PRICE}        2900.99
${VALID_PRODUCT_DESC}         Description du produit de test
${VALID_PRODUCT_CATEGORY}     electronics
${VALID_PRODUCT_QUANTITY}     100
${VALID_PRODUCT_IMAGE}        https://example.com/image.jpg

    
# Variables pour les tests non passants
${INVALID_PRODUCT_TITLE }        None  # Titre vide
${INVALID_PRODUCT_PRICE }        "not_a_number"  # Prix non numérique
${INVALID_PRODUCT_DESC }        None    #Description nulle
${INVALID_PRODUCT_CATEGORY}       123  # Catégorie non textuelle
${INVALID_PRODUCT_QUANTITY}       -1  # Quantité négative
${INVALID_PRODUCT_IMAGE }        "invalid_url"  # URL invalide


# Variables pour les tests utilisateurs
${VALID_USER_FIRSTNAME}       ndiankou
${VALID_USER_LASTNAME}        Ndoye
${VALID_USER_EMAIL}           ndiankou.ndoye.test@example.com
${VALID_USER_USERNAME}        ndiankou
${VALID_USER_PASSWORD}        password123
${VALID_USER_PHONE}           +221771234567
${INVALID_EMAIL}              invalid_email_format
${INVALID_USER_USERNAME}           invalid_username!@#  # Caractères spéciaux non autorisés
${INVALID_PASSWORD}           short  # Mot de passe trop court


# Variables pour les tests de panier
${VALID_CART_PRODUCT_QUANTITY}    5
${INVALID_CART_PRODUCT_QUANTITY}   -1
