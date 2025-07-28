# mongodb_keywords.py
import pymongo
from robot.api.deco import keyword

class MongoDBKeywords:

    def __init__(self):
        self.client = None
        self.database = None

    @keyword
    def connect_to_mongodb_atlas(self, connection_string, database_name):
        self.client = pymongo.MongoClient(connection_string)
        self.database = self.client[database_name]
        return "Connected successfully"

    @keyword
    def insert_document(self, collection_name, document):
        collection = self.database[collection_name]
        result = collection.insert_one(document)
        return str(result.inserted_id)

    @keyword
    def find_documents(self, collection_name, query=None):
        if query is None:
            query = {}
        collection = self.database[collection_name]
        return list(collection.find(query))