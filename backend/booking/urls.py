from django.urls import path, include
from .views import *
from rest_framework import routers

router = routers.DefaultRouter()
router.register(r'rooms', RoomViewSet)
router.register(r'user', UserViewSet)
router.register(r'books', BookingViewSet)
router.register(r'favorites', FavsViewSet)
# router.register(r'favs', FavsViewSet)
router.register(r'reservations', ReservationViewSet)
urlpatterns = [
path('roomList/', RoomListView.as_view()),
path('bookingList/', BookingListView.as_view()),
path('HotelListView/', HotelListView.as_view()),
path('hotels/<int:hotel_id>/likes/', update_likes),

path('create_favoris', create_favoris),
path('hotels/<int:pk>/like/', like_hotel),
path('hotels/<int:hotel_id>/like/', add_favorite, name='add_favorite'),
path('reservations/<int:reservation_id>/delete/', delete_reservation, name='delete_reservation'),

path('api/hotels/<int:hotel_id>/rooms/', include(router.urls)),
path('api/bookings/<int:user_id>/books/', include(router.urls)),
path('api/favs/<int:user_id>/favorites/', include(router.urls)),
# path('users/<int:user>/favorites/', FavsViewSet),
# path('users/<int:user_id>/favorites/', get_user_favorites),
path('api/info/<int:id>/infos/', include(router.urls)),
path('api/', include(router.urls)),
path('api/reservation/', make_reservation, name='make_reservation'),
path('reservations/<str:username>/<int:room_id>/<str:date>/', reservation_view, name='reservation'),
path('hotels/<str:place>', HotelSearchView.as_view()),
# path('rooms/<int:pk>/reserve/', RoomReservationView.as_view(), name='room_reserve'),
]