from rest_framework.authentication import TokenAuthentication

class BearerAuthentication(TokenAuthentication):
    """
        If you want to use a different keyword in the header, such as Bearer, simply subclass TokenAuthentication and set the keyword class variable.
    """
    keyword = "Bearer"