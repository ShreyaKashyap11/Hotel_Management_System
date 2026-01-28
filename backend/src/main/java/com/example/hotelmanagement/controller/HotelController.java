package com.example.hotelmanagement.controller;

import com.example.hotelmanagement.model.Hotel;
import com.example.hotelmanagement.service.HotelService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api/hotels")
@CrossOrigin(origins = "*")
public class HotelController {
    private final HotelService service;

    public HotelController(HotelService service) {
        this.service = service;
    }

    @GetMapping
    public List<Hotel> getAll() {
        return service.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Hotel> getById(@PathVariable Long id) {
        return service.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Hotel> create(@RequestBody Hotel hotel) {
        Hotel created = service.create(hotel);
        return ResponseEntity.created(URI.create("/api/hotels/" + created.getId())).body(created);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Hotel> update(@PathVariable Long id, @RequestBody Hotel hotel) {
        return service.update(id, hotel)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        boolean deleted = service.delete(id);
        return deleted ? ResponseEntity.noContent().build() : ResponseEntity.notFound().build();
    }
}