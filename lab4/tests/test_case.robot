*** Settings ***
Library    AppiumLibrary
#Variables  ../resources/locator.py
Resource    ../resources/keyword.robot

*** Test Cases **
Test d'authentification valide
    [Documentation]    Test de connexion avec des identifiants valides
    Ouvrir l'application
    Vérifier la page de connexion
    Saisir les identifiants    johnd    m38rmF$
    Cliquer sur le bouton de connexion
    Vérifier la connexion réussie


Test de création de produit
    [Documentation]    Test de création d'un produit avec des données valides
    Ouvrir l'application
    Vérifier la page de connexion
    Saisir les identifiants    johnd    m38rmF$
    Cliquer sur le bouton de connexion
    Vérifier la connexion réussie
    Saisir le titre du produit    Test Product
    Saisir le prix du produit    1000.00
    Saisir la description du produit    Ceci est une description du produit de test.
    Saisir la catégorie du produit    Catégorie du produit
    Saisir l'uRL de l'image du produit    https://example.com/image.jpg
    Cliquer sur le button ajouter
    Sleep    5s
    Rechercher le produit