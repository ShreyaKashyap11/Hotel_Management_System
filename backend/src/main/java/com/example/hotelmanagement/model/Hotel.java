package com.example.hotelmanagement.model;

import jakarta.persistence.*;

@Entity
@Table(name = "hotels")
public class Hotel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String address;
    private Double rating;
    private Integer roomsAvailable;
    private Double pricePerNight;

    public Hotel() {}

    public Hotel(String name, String address, Double rating, Integer roomsAvailable, Double pricePerNight) {
        this.name = name;
        this.address = address;
        this.rating = rating;
        this.roomsAvailable = roomsAvailable;
        this.pricePerNight = pricePerNight;
    }

    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public Double getRating() { return rating; }
    public void setRating(Double rating) { this.rating = rating; }

    public Integer getRoomsAvailable() { return roomsAvailable; }
    public void setRoomsAvailable(Integer roomsAvailable) { this.roomsAvailable = roomsAvailable; }

    public Double getPricePerNight() { return pricePerNight; }
    public void setPricePerNight(Double pricePerNight) { this.pricePerNight = pricePerNight; }
}