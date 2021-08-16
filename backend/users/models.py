from django.db import models

class User(models.Model):
    name = models.CharField(max_length=100)
    email = models.CharField(max_length=100)
    password = models.CharField(max_length=100)

    def __str__(self):
        return self.name

# class Attendee(models.Model):
#     name = models.CharField(max_length=100, default="Filler Name")
#     email = models.CharField(max_length=100, default="filler@gmail.com")
#     attendingUser = models.ForeignKey(User, on_delete=models.CASCADE, default=1)

#     def __str__(self):
#         return self.attendeeName

class Event(models.Model):
    name = models.CharField(max_length=100)
    date = models.DateTimeField()
    startTime = models.TimeField(default="14:30:59")
    endTime = models.TimeField(default="14:30:59")
    tag = models.CharField(max_length=100)
    user = models.ForeignKey(User, on_delete=models.CASCADE, default=1, related_name="user")
    location = models.CharField(max_length=100)
    description = models.CharField(max_length=100, default="Event")
    attendees = models.ManyToManyField(User, related_name="attending_users")
    
    def __str__(self):
        return self.name