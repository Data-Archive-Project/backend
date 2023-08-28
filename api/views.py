from django.db.models import Q
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.authtoken.models import Token
from rest_framework import status, serializers, generics
from rest_framework.permissions import IsAuthenticated
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.pagination import PageNumberPagination
from django.http import FileResponse
from django.http import Http404
from django.contrib.auth import login, authenticate
from django.core.exceptions import ObjectDoesNotExist

from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema

from .utils import BearerAuthentication
from .serializers import *
from .models import *
from .email import send_document_email


class Login(APIView):
    response_schema_dict = {
            "201": openapi.Response(
                description="",
                examples={
                    "application/json": {
                        'token': "usertokenstring",
                        'user_id': "integer",
                    }
                }
            )
    }

    @swagger_auto_schema(request_body=LoginSerializer, responses=response_schema_dict)
    def post(self, request):
        """
            Returns an Authentication Bearer Token given valid user email and password.
        """

        # get data from request body
        serializer = LoginSerializer(data=request.data)

        if serializer.is_valid():

            # find user using id
            try:
                profile = Profile.objects.get(staff_id=serializer.data['staff_id'])
                user = profile.user
                print(user)
            except ObjectDoesNotExist:
                return Response(data={"auth_error": "Invalid ID"}, status=status.HTTP_401_UNAUTHORIZED,)

            # authenticate User
            user = authenticate(username=user.username, password=serializer.data['password'])

            # authenticate role and return user's token
            if user is not None and user.profile.is_admin == serializer.data['is_admin']:
                token, created = Token.objects.get_or_create(user=user)
                return Response(data={
                    'token': token.key,
                    'user_id': user.pk,
                    'is_admin': user.profile.is_admin
                }, status=status.HTTP_200_OK)

            else:
                return Response(data={"auth_error": "Invalid Password or Role"}, status=status.HTTP_401_UNAUTHORIZED,)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class RankList(APIView):
    """
        List all ranks, or create a new rank.
    """
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(responses={"200": RankSerializer(many=True)})
    def get(self, request):
        ranks = Rank.objects.all()
        serializer = RankSerializer(ranks, many=True)
        return Response(serializer.data)

    @swagger_auto_schema(request_body=RankSerializer(), responses={"200": RankSerializer()})
    def post(self, request):
        serializer = RankSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class RankDetail(APIView):
    """
        Retrieve, update or delete a rank instance.
    """

    # drf-yasg stuff
    manual_parameters = [
        openapi.Parameter(name="id", required=True, type="integer", in_=openapi.IN_PATH, description="instance id", ),
    ]

    def get_object(self, pk):
        try:
            return Rank.objects.get(id=pk)
        except Rank.DoesNotExist:
            raise Http404

    @swagger_auto_schema(responses={"200": RankSerializer()}, manual_parameters=manual_parameters)
    def get(self, request, id, format=None):
        """
            Retrieve a rank instance
        """
        rank = self.get_object(id)
        serializer = RankSerializer(rank)
        return Response(serializer.data)

    @swagger_auto_schema(request_body=RankSerializer(), responses={"200": RankSerializer()}, manual_parameters=manual_parameters)
    def put(self, request, id):
        """
            update a rank instance
        """
        rank = self.get_object(id)
        serializer = RankSerializer(rank, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @swagger_auto_schema(responses={"204": None}, manual_parameters=manual_parameters)
    def delete(self, request, id):
        """
            delete a rank instance
        """
        rank = self.get_object(id)
        rank.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class PositionList(generics.ListCreateAPIView):
    """
        List all positions, or creates a new position. (written using generics: abstractions go brrrrrrrrr)
    """
    pagination_class = None
    queryset = Position.objects.all()
    serializer_class = PositionSerializer
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]


class PositionDetail(generics.RetrieveUpdateDestroyAPIView):
    """
        Retrieve, update or delete a position instance.
    """
    queryset = Position.objects.all()
    serializer_class = PositionSerializer
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]


class UserList(generics.ListCreateAPIView):
    """
        List all Users
    """
    pagination_class=None
    queryset = User.objects.all()
    serializer_class = UserSerializer
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]


class UserDetail(generics.RetrieveUpdateDestroyAPIView):
    """
        Retrieve, update or delete a User instance.
    """
    queryset = User.objects.all()
    serializer_class = UserSerializer
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]


class CategoryList(APIView):
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(responses={"200": CategorySerializer(many=True)})
    def get(self, request):
        categories = Category.objects.all()
        serializer = CategorySerializer(categories, many=True, context={'request': request})
        return Response(serializer.data)

    @swagger_auto_schema(request_body=CategorySerializer(), responses={"201": CategorySerializer(many=True)})
    def post(self, request):
        serializer = CategorySerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_201_CREATED)


class CategoryDetail(APIView):
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]

    # drf-yasg stuff
    manual_parameters = [
        openapi.Parameter(name="id", required=True, type="integer", in_=openapi.IN_PATH, description="instance id", ),
    ]

    def get_object(self, pk):
        """
        get category object
        """
        try:
            return Category.objects.get(id=pk)
        except Category.DoesNotExist:
            raise Http404

    @swagger_auto_schema(responses={"200": CategorySerializer()}, manual_parameters=manual_parameters)
    def get(self, request, id):
        """
        GET a category instance
        """
        category = self.get_object(id)
        serializer = CategorySerializer(category, context={'request': request})
        return Response(serializer.data, status=status.HTTP_200_OK)

    @swagger_auto_schema(request_body=CategorySerializer(), responses={"201": CategorySerializer()}, manual_parameters=manual_parameters)
    def patch(self, request, id):
        category = self.get_object(id)
        serializer = CategorySerializer(category, data=request.data, partial=True, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @swagger_auto_schema(request_body=CategorySerializer(), responses={"201": CategorySerializer()},
                         manual_parameters=manual_parameters)
    def put(self, request, id):
        category = self.get_object(id)
        serializer = CategorySerializer(category, data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @swagger_auto_schema(responses={"204": None}, manual_parameters=manual_parameters)
    def delete(self, request, id):
        category = self.get_object(id)
        category.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class DocumentList(APIView):
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]
    parser_classes = (MultiPartParser, FormParser)

    @swagger_auto_schema(operation_description="Get a list of documents", manual_parameters=[
            openapi.Parameter(
                name='page',
                in_=openapi.IN_QUERY,
                type=openapi.TYPE_INTEGER,
                description='Page number for pagination',
                required=False
            ),
            openapi.Parameter(
                name='category',
                in_=openapi.IN_QUERY,
                type=openapi.TYPE_STRING,
                description='Category tag to filter documents',
                required=False
            ),
            openapi.Parameter(
                name='approval_status',
                in_=openapi.IN_QUERY,
                type=openapi.TYPE_STRING,
                description='pending, approved, rejected; filter by approval status',
                required=False
            ),
            openapi.Parameter(
                name='search',
                in_=openapi.IN_QUERY,
                type=openapi.TYPE_STRING,
                description='search query',
                required=False
            ),
        ],
        responses={
            200: openapi.Response(
                description="OK",
                schema=openapi.Schema(
                    type=openapi.TYPE_OBJECT,
                    properties={
                        'count': openapi.Schema(type=openapi.TYPE_INTEGER),
                        'next': openapi.Schema(type=openapi.TYPE_STRING),
                        'previous': openapi.Schema(type=openapi.TYPE_STRING),
                        'results': openapi.Schema(
                            type=openapi.TYPE_ARRAY,
                            items=openapi.Schema(
                                type=openapi.TYPE_OBJECT,
                                properties={
                                    'id': openapi.Schema(type=openapi.TYPE_INTEGER),
                                    'title': openapi.Schema(type=openapi.TYPE_STRING),
                                    'description': openapi.Schema(type=openapi.TYPE_STRING),
                                    'source': openapi.Schema(type=openapi.TYPE_STRING),
                                    'file_type': openapi.Schema(type=openapi.TYPE_STRING),
                                    'file': openapi.Schema(type=openapi.TYPE_STRING),
                                    'category': openapi.Schema(type=openapi.TYPE_INTEGER),
                                    'uploaded_by': openapi.Schema(type=openapi.TYPE_INTEGER),
                                    'read_access': openapi.Schema(
                                        type=openapi.TYPE_ARRAY,
                                        items=openapi.Schema(type=openapi.TYPE_INTEGER)
                                    ),
                                    'update_access': openapi.Schema(
                                        type=openapi.TYPE_ARRAY,
                                        items=openapi.Schema(type=openapi.TYPE_INTEGER)
                                    ),
                                    'position_access': openapi.Schema(
                                        type=openapi.TYPE_ARRAY,
                                        items=openapi.Schema(type=openapi.TYPE_INTEGER)
                                    ),
                                    "date_received": openapi.Schema(type=openapi.FORMAT_DATE),
                                    "created_at": openapi.Schema(type=openapi.FORMAT_DATE),
                                    "approval_status": openapi.Schema(type=openapi.TYPE_STRING),
                                    "versions": openapi.Schema(
                                        type=openapi.TYPE_ARRAY,
                                        items=openapi.Schema(
                                            type=openapi.TYPE_OBJECT,
                                            properties={
                                                "document": openapi.Schema(type=openapi.TYPE_INTEGER),
                                                "version_number": openapi.Schema(type=openapi.TYPE_INTEGER),
                                                "changes": openapi.Schema(type=openapi.TYPE_STRING),
                                                "changed_by": openapi.Schema(type=openapi.TYPE_INTEGER),
                                                "created_at": openapi.Schema(type=openapi.FORMAT_DATE),
                                            },
                                        ),
                                    ),
                                },
                            ),
                        ),
                    },
                ),
            ),
        },
    )
    def get(self, request):
        """
            Get a list of documents ?page=1&category=kdf&
        """

        # filter documents by the user access
        user = self.request.user
        if user.profile.is_admin:
            # all documents if user is admin
            documents = Document.objects.all()
        else:
            # only documents the user has access to
            documents = None
            read_documents = user.access_documents.all()
            print(f"read_documents: {read_documents}")
            update_documents = user.update_documents.all()
            print(f"update_documents: {update_documents}")

            # add read and update documents to the documents queryset
            documents = read_documents | update_documents

            # documents the user uploaded
            uploaded_documents = Document.objects.filter(uploaded_by=user)


            # add uploaded documents to the documents queryset
            documents = documents | uploaded_documents

            if user.profile.position:
                position = user.profile.position
                position_access_documents = position.position_documents.all()

                # documents approved by the user
                approved_documents = Approval.objects.filter(approved_by=user).values_list('document', flat=True)

                documents = documents | position_access_documents | approved_documents
            print(user)

        # make sure there are no duplicates
        documents = documents.distinct()
        print(documents)

        # Search functionality
        search_query = request.GET.get('search')
        if search_query:
            search_query = search_query.lower()
            documents = documents.filter(
                Q(title__icontains=search_query) |
                Q(description__icontains=search_query) |
                Q(source__icontains=search_query)
            )

        # todo: Sorting functionality
        ...

        # todo: Filter by user_id
        ...

        # todo: filter by approval status
        status_ = request.GET.get('approval_status')
        if status_:
            documents = documents.approvals.filter(status=status_)

        # Filter documents by category if provided as a query parameter
        category = request.GET.get('category')
        if category:
            category = Category.objects.get(tag=category)
            documents = documents.filter(category=category.id)

        # filter by user
        user = request.GET.get("user")
        if user:
            user = User.objects.get(id=user)
            # filter by user in read_access, update_access, position_access
            documents = documents.filter(
                Q(read_access=user) |
                Q(update_access=user) |
                Q(position_access=user.profile.position)
            )

        # Paginate the documents
        paginator = PageNumberPagination()
        paginated_documents = paginator.paginate_queryset(documents, request)

        # Serialize the paginated documents
        serializer = DocumentSerializer(paginated_documents, many=True)

        return paginator.get_paginated_response(serializer.data)

    @swagger_auto_schema(request_body=DocumentSerializer(), responses={"201": DocumentSerializer()})
    def post(self, request):
        # Get file
        file = request.FILES.get("file")

        # GET data
        data = request.POST.copy()

        # Remove the 'file' key from the copied data dictionary
        data.pop("file", None)

        # add or override 'uploaded_by'
        data["uploaded_by"] = request.user.pk

        # serialize form data
        serializer = DocumentSerializer(data=data)

        if serializer.is_valid():
            # Save the serializer and associate the file separately
            document = serializer.save()
            document.file = file
            document.save()

            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class DocumentDetail(APIView):
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]
    parser_classes = (MultiPartParser, FormParser)

    def get_object(self, pk):
        try:
            return Document.objects.get(id=pk)
        except:
            raise Http404

    @swagger_auto_schema(responses={
            200: openapi.Response(
                description="OK",
                schema=openapi.Schema(
                    type=openapi.TYPE_OBJECT,
                            properties={
                                'id': openapi.Schema(type=openapi.TYPE_INTEGER),
                                'title': openapi.Schema(type=openapi.TYPE_STRING),
                                'description': openapi.Schema(type=openapi.TYPE_STRING),
                                'source': openapi.Schema(type=openapi.TYPE_STRING),
                                'file_type': openapi.Schema(type=openapi.TYPE_STRING),
                                'file': openapi.Schema(type=openapi.TYPE_STRING),
                                'category': openapi.Schema(type=openapi.TYPE_INTEGER),
                                'uploaded_by': openapi.Schema(type=openapi.TYPE_INTEGER),
                                'read_access': openapi.Schema(
                                    type=openapi.TYPE_ARRAY,
                                    items=openapi.Schema(type=openapi.TYPE_INTEGER)
                                ),
                                'update_access': openapi.Schema(
                                    type=openapi.TYPE_ARRAY,
                                    items=openapi.Schema(type=openapi.TYPE_INTEGER)
                                ),
                                'position_access': openapi.Schema(
                                    type=openapi.TYPE_ARRAY,
                                    items=openapi.Schema(type=openapi.TYPE_INTEGER)
                                ),
                                "date_received": openapi.Schema(type=openapi.FORMAT_DATE),
                                "created_at": openapi.Schema(type=openapi.FORMAT_DATE),
                                "approval_status": openapi.Schema(type=openapi.TYPE_STRING),
                                "versions": openapi.Schema(
                                    type=openapi.TYPE_ARRAY,
                                    items=openapi.Schema(
                                        type=openapi.TYPE_OBJECT,
                                        properties={
                                            "document": openapi.Schema(type=openapi.TYPE_INTEGER),
                                            "version_number": openapi.Schema(type=openapi.TYPE_INTEGER),
                                            "changes": openapi.Schema(type=openapi.TYPE_STRING),
                                            "changed_by": openapi.Schema(type=openapi.TYPE_INTEGER),
                                            "created_at": openapi.Schema(type=openapi.FORMAT_DATE),
                                        },
                                    ),
                                ),
                            },
                        ),
                    ),
    },)
    def get(self, request, id, format=None):
        """
        Get the details of a document
        """

        # get the user
        user = request.user

        # get the document
        document = self.get_object(id)

        # check if user is allowed access to the document
        if user.profile.is_admin:
            # user has access
            serializer = DocumentSerializer(document)
        else:
            # user does not have access
            if document in user.access_documents.all() or user.update_documents.all() or user.profile.position.position_documents.all():
                # user has access
                serializer = DocumentSerializer(document)
            else:
                # user does not have access
                return Response({"error": "You do not have access to this document"}, status=status.HTTP_403_FORBIDDEN)

        serializer = DocumentSerializer(document)
        return Response(serializer.data, status=status.HTTP_200_OK)

    @swagger_auto_schema(request_body=DocumentSerializer(), responses={"201": DocumentSerializer()})
    def patch(self, request, id):
        document = self.get_object(id)

        # Get file
        file = request.FILES.get("file")

        # GET data
        data = request.data
        data = request.data.copy()  # Create a copy of the request data

        # Remove the 'file' key from the copied data dictionary
        if file:
            data.pop('file', None)

        # add or override 'uploaded_by'
        # data["uploaded_by"] = request.user.pk

        changes = data.get("changes")

        # serialize form data
        serializer = DocumentSerializer(document, data=data, partial=True)

        if serializer.is_valid():
            # Save the serializer and associate the file separately
            document = serializer.save()
            if file:
                document.file = file
                document.save()
                if changes:
                    # create a document version
                    version = Version.objects.create(document=document, version_number=document.versions.count() + 1,
                                                     changes=changes, changed_by=document.uploaded_by)
                else:
                    # create a document version
                    version = Version.objects.create(document=document, version_number=document.versions.count() + 1,
                                                     changes="No Changes Specified", changed_by=document.uploaded_by)
            print("yapari")

            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, id):
        """
        Delete a Document Instance
        """
        d = self.get_object(id)
        d.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class ApprovalList(APIView):
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(responses={"200": ApprovalSerializer(many=True)})
    def get(self, request):
        if request.user.profile.is_admin:
            approvals = Approval.objects.all()
        elif request.user.profile.position:
            approvals = Approval.objects.filter(approver=request.user.profile.position)
        else: approvals = Approval.objects.all()

        # filter approvals by status
        if request.GET.get("status"):
            print("trueeeeeee")
            filter_by = request.GET.get("status")
            approvals = approvals.filter(status=filter_by)

        serializer = ApprovalSerializer(approvals, many=True)

        return Response(serializer.data)


class ApprovalDetail(APIView):
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]

    # drf-yasg stuff
    manual_parameters = [
        openapi.Parameter(name="id", required=True, type="integer", in_=openapi.IN_PATH, description="instance id", ),
    ]

    def get_object(self, id):
        """
        get category object
        """
        try:
            return Approval.objects.get(id=id)
        except ObjectDoesNotExist:
            raise Http404

    @swagger_auto_schema(request_body=ApprovalSerializer(), responses={"201": ApprovalSerializer()}, manual_parameters=manual_parameters)
    def patch(self, request, id):
        """
        Partially update an approval
        """
        approval = self.get_object(id)
        serializer = ApprovalSerializer(approval, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, id):
        """
        Delete an Approval Instance
        """
        d = self.get_object(id)
        d.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class CommentList(APIView):
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(responses={"200": CommentSerializer(many=True)})
    def get(self, request):

        comments = Comment.objects.all()

        # filter comments by a document
        if request.GET.get("document"):
            filter_by = request.GET.get("document")
            comments = Comment.objects.filter(document=int(filter_by))

        serializer = CommentSerializer(comments, many=True)

        return Response(serializer.data)

    @swagger_auto_schema(request_body=CommentSerializer(), responses={"201": CommentSerializer(many=True)})
    def post(self, request):
        serializer = CommentSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_201_CREATED)


class NotificationList(APIView):
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(responses={"200": NotificationSerializer(many=True)})
    def get(self, request):

        user = request.user

        # filter notifications by a user
        notifications = Notification.objects.filter(receiver=user.pk)

        serializer = NotificationSerializer(notifications, many=True)

        return Response(serializer.data)


class NotificationDetail(APIView):
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]

    # drf-yasg stuff
    manual_parameters = [
        openapi.Parameter(name="id", required=True, type="integer", in_=openapi.IN_PATH, description="instance id", ),
    ]

    def get_object(self, pk):
        """
        get category object
        """
        try:
            return Notification.objects.get(id=pk)
        except ObjectDoesNotExist:
            raise Http404

    @swagger_auto_schema(request_body=NotificationSerializer(), responses={"201": NotificationSerializer()}, manual_parameters=manual_parameters)
    def patch(self, request, id):
        """
        Partially update a Notification ("isread" to true)
        """
        notification = self.get_object(id)
        serializer = NotificationSerializer(notification, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class VersionList(APIView):
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(responses={"200": VersionSerializer(many=True)})
    def get(self, request):

        versions = Version.objects.all()

        # filter versions by a document
        if request.GET.get("document"):
            filter_by = request.GET.get("document")
            versions = Version.objects.filter(document=int(filter_by))

        serializer = VersionSerializer(versions, many=True)

        return Response(serializer.data)


def get_documents_created_in_month(year, month):
    documents = Document.objects.filter(
        Q(created_at__year=year, created_at__month=month)
    )
    return documents


class MonthlyArchiveAPIView(APIView):
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(manual_parameters=[
            openapi.Parameter(
                name='year',
                in_=openapi.IN_QUERY,
                type=openapi.TYPE_INTEGER,
                description='Year to filter documents',
                required=True
            ),
            openapi.Parameter(
                name='month',
                in_=openapi.IN_QUERY,
                type=openapi.TYPE_INTEGER,
                description='Month to filter documents',
                required=True
            )], responses={"200": DocumentSerializer(many=True)})
    def get(self, request):
        year = request.query_params.get('year')
        month = request.query_params.get('month')

        if not year or not month:
            return Response(
                {"error": "Year and month parameters are required."},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            year = int(year)
            month = int(month)
        except ValueError:
            return Response(
                {"error": "Year and month must be valid integers."},
                status=status.HTTP_400_BAD_REQUEST
            )

        documents = get_documents_created_in_month(year, month)

        # filter documents by the user access
        user = self.request.user
        if user.profile.is_admin:
            pass
        else:
            # filter documents by the user access
            documents = documents.filter(Q(read_access__in=[user.pk]) | Q(update_access__in=[user.pk]))

        serializer = DocumentSerializer(documents, many=True)
        return Response(serializer.data)


def serve_file(request, file_path):
    """
    Serve a file from the server
    """
    from pathlib import Path
    project_folder = Path(__file__).parent.parent.resolve()
    my_file = project_folder / file_path
    return FileResponse(open(str(my_file), 'rb'), as_attachment=True)


class SendEmail(APIView):
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(request_body=EmailSerializer(), responses={"201": EmailSerializer()})
    def post(self, request):

        user = request.user

        serializer = EmailSerializer(data=request.data)
        if serializer.is_valid():
            recipients = serializer.data.get('recipients')
            subject = serializer.data.get('subject')
            message = serializer.data.get('message')
            document_id = serializer.data.get('document_id')

            file = Document.objects.get(id=document_id)
            file_path = file.file.path

            send_document_email(recipients, subject, message, user.email, file_path)
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_201_CREATED)