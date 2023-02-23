from rest_framework.decorators import api_view
from rest_framework.response import Response
from datetime import date
from django.shortcuts import render,get_object_or_404
from rest_framework import generics,viewsets
from rest_framework.generics import ListAPIView
from .models import Room,Booking,Hotel
from hotel.models import User
from .serializer import RoomSerializer,BookingSerializer,HotelSerializer,UserSerializer,FavoriteSerializer
from django.http import JsonResponse
from .models import *
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import authenticate
from rest_framework.authtoken.models import Token
from rest_framework.decorators import api_view


@api_view(['POST'])
def make_reservation(request):
    if request.method == 'POST':
        try:
            username = request.data['username']
            room_id = request.data['room_id']
            datee = request.data['date']
            print(str(username)+" "+str(room_id)+" "+str(datee))
        except:
            return Response(
                {
                    'message':"envoyer tous les champs"
                },
                status=status.HTTP_400_BAD_REQUEST
            )
        try:
            room = Room.objects.get(id=room_id)
            user = User.objects.get(username=username)
            reservation = Booking.objects.create(
                room=room,
                user=user,
                date=date.today()
            )
            return Response(
                {
                    'message':"Parfait"
                },
                status=status.HTTP_201_CREATED
            )
        except Room.DoesNotExist:
            return Response(
                {
                    'message':"Room doesnt exist"
                },
                status=status.HTTP_400_BAD_REQUEST
            )
        except:
            return Response(
                {
                    'message':"data are not valid"
                },
                status=status.HTTP_400_BAD_REQUEST
            )
    return JsonResponse({'status': 'error', 'message': 'Invalid request method'})


def reservation_view(request, username, room_id, date):
    user = get_object_or_404(User, username=username)
    room = get_object_or_404(Room, pk=room_id)
    reservation = get_object_or_404(Booking, room=room, user=user, date=date)
    return render(request, 'reservation.html', {'reservation': reservation})

# Reservation
class ReservationViewSet(viewsets.ModelViewSet):
    queryset = Booking.objects.all()
    serializer_class = BookingSerializer


# Create your views here.
class HotelListView(generics.ListAPIView):
    queryset=Hotel.objects.all()
    serializer_class=HotelSerializer
    

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

    def get_queryset(self):
        id = self.kwargs['id']
        return User.objects.filter(id=id)    
class RoomViewSet(viewsets.ModelViewSet):
    queryset = Room.objects.all()
    serializer_class = RoomSerializer

    def get_queryset(self):
        hotel_id = self.kwargs['hotel_id']
        return Room.objects.filter(hotel_id=hotel_id)    


# Likes
@api_view(['POST'])
def update_likes(request, hotel_id):
    try:
        hotel = Hotel.objects.get(pk=hotel_id)
    except Hotel.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    
    # augmenter les likes de l'hotel
    hotel.likes += 1
    hotel.save()
    
    # renvoyer le nombre de likes mis à jour
    return Response({'likes': hotel.likes}, status=status.HTTP_200_OK)
# likes
@api_view(['POST'])
def like_hotel(request ,pk):
    user = request.user # ou récupérez l'utilisateur à partir de la demande
    hotel = get_object_or_404(Hotel, pk=pk)
    if user in hotel.favoris.all():
        hotel.favoris.remove(user)
        hotel.likes -= 1
        hotel.save()
        return Response({"message": "Hotel a été retiré de la liste des favoris"}, status=status.HTTP_200_OK)
    else:
        hotel.favoris.add(user)
        hotel.likes += 1
        hotel.save()
        return Response({"message": "Hotel a été ajouté à la liste des favoris"}, status=status.HTTP_200_OK)
    

@api_view(['POST'])
def create_favoris(request):
    data = request.data
    try:
        hotel_id = data['hotel']
        user_id = data['user']
        hotel = Hotel.objects.get(id=hotel_id)
        user = User.objects.get(id=user_id)
    except:
        return Response({'error': 'Invalid request data'}, status=400)

    if Favorise.objects.filter(hotel=hotel, user=user).exists():
        return Response({'error': 'Favoris existe déjà'}, status=400)

    hotel.likes += 1
    hotel.save()

    favoris = Favorise.objects.create(hotel=hotel, user=user)
    serializers = FavoriteSerializer(favoris, many=False)
    return Response(serializers.data)

# # @api_view(['GET'])
# def get_user_favorites(viewsets.ModelViewSet):
#     queryset = Favorise.objects.all()
#     serializer_class = FavoriteSerializer

#     def get_queryset(self):
#         user_id = self.kwargs['user_id']
#         return Favorise.objects.filter(user__id=user_id)
    
@api_view(['POST'])
def add_favorite(request):
    serializer = FavoriteSerializer(data=request.data)
    if serializer.is_valid():
        # Vérification si l'utilisateur existe
        user_id = serializer.validated_data['id_user']
        try:
            user = User.objects.get(id=user_id)
        except User.DoesNotExist:
            return Response({'error': 'Utilisateur inexistant.'}, status=status.HTTP_400_BAD_REQUEST)

        # Vérification si l'hôtel existe
        hotel_id = serializer.validated_data['id_hotel']
        try:
            hotel = Hotel.objects.get(id=hotel_id)
        except Hotel.DoesNotExist:
            return Response({'error': 'Hôtel inexistant.'}, status=status.HTTP_400_BAD_REQUEST)

        # Vérification si le favori n'existe pas déjà
        if Favorite.objects.filter(id_user=user_id, id_hotel=hotel_id).exists():
            return Response({'error': 'Le favori existe déjà.'}, status=status.HTTP_400_BAD_REQUEST)

        # Création du favori
        favorite = Favorite(id_user=user, id_hotel=hotel)
        favorite.save()

        # Augmentation du nombre de likes de l'hôtel
        hotel.likes += 1
        hotel.save()

        return Response({'success': 'Favori ajouté avec succès.'}, status=status.HTTP_201_CREATED)

    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
#end Likes 
class BookingViewSet(viewsets.ModelViewSet):
    queryset = Booking.objects.all()
    serializer_class = BookingSerializer

    def get_queryset(self):
        user_id = self.kwargs['user_id']
        return Booking.objects.filter(user__id=user_id)    
# Favories
class FavsViewSet(viewsets.ModelViewSet):
    queryset = Favorise.objects.all()
    serializer_class = FavoriteSerializer

    def get_queryset(self):
        user_id = self.kwargs['user_id']
        return Favorise.objects.filter(user__id=user_id)

# Delete Reservation
@api_view(['DELETE'])
def delete_reservation(request, reservation_id):
    reservation = get_object_or_404(Booking, id=reservation_id)
    reservation.delete()
    return redirect('bookingList')

   
class RoomReservationView(generics.RetrieveUpdateAPIView):
    queryset = Room.objects.all()
    serializer_class = RoomSerializer

    def perform_update(self, serializer):
        room = self.get_object()
        room.available = False
        room.save()
    
class RoomListView(generics.ListAPIView):
    queryset=Room.objects.all()
    serializer_class=RoomSerializer
    
class BookingListView(generics.ListAPIView):
    queryset=Booking.objects.all()
    serializer_class=BookingSerializer
    
    
# Search Hotel
class HotelSearchView(generics.ListAPIView):
    serializer_class = HotelSerializer

    def get_queryset(self):
        place = self.kwargs.get('place', None)
        if place is not None:
            return Hotel.objects.filter(place__iexact=place)
        return Hotel.objects.none()