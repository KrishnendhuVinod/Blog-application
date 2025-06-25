from django.urls import path
from .views import LoginView, PostListView, PostDetailView, CreatePostView, home

urlpatterns = [
    path('', home),
    path('login/', LoginView.as_view()),
    path('posts/', PostListView.as_view()),
    path('posts/<int:id>/', PostDetailView.as_view()),
    path('posts/create/', CreatePostView.as_view(), name='create-post'), 
]
