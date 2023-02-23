from rest_framework import serializers
from .models import Hotel,Room,Booking,Favorise
from hotel.models import User



class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'
class HotelSerializer(serializers.ModelSerializer):
    class Meta:
        model = Hotel
        fields = '__all__'
class FavoriteSerializer(serializers.ModelSerializer):
    hotel = HotelSerializer(many=False, read_only=True)

    class Meta:
        model = Favorise
        fields = ['user','hotel']
class RoomSerializer(serializers.ModelSerializer):
    class Meta:
        model = Room
        fields = '__all__'
class BookingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Booking
        fields = '__all__'

