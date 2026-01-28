package com.example.hotelmanagement.service;

import com.example.hotelmanagement.model.Hotel;
import com.example.hotelmanagement.repository.HotelRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class HotelService {
    private final HotelRepository repo;

    public HotelService(HotelRepository repo) {
        this.repo = repo;
    }

    public List<Hotel> findAll() {
        return repo.findAll();
    }

    public Optional<Hotel> findById(Long id) {
        return repo.findById(id);
    }

    public Hotel create(Hotel hotel) {
        hotel.setId(null);
        return repo.save(hotel);
    }

    public Optional<Hotel> update(Long id, Hotel newHotel) {
        return repo.findById(id).map(h -> {
            h.setName(newHotel.getName());
            h.setAddress(newHotel.getAddress());
            h.setRating(newHotel.getRating());
            h.setRoomsAvailable(newHotel.getRoomsAvailable());
            h.setPricePerNight(newHotel.getPricePerNight());
            return repo.save(h);
        });
    }

    public boolean delete(Long id) {
        return repo.findById(id).map(h -> {
            repo.delete(h);
            return true;
        }).orElse(false);
    }
}