import React, { useEffect, useState } from "react";
import api from "../api";

export default function HotelForm({ editing, onSaved }) {
  const [form, setForm] = useState({
    name: "",
    address: "",
    rating: 0,
    roomsAvailable: 0,
    pricePerNight: 0
  });

  useEffect(() => {
    if (editing) setForm(editing);
    else setForm({ name: "", address: "", rating: 0, roomsAvailable: 0, pricePerNight: 0 });
  }, [editing]);

  const handleChange = e => {
    const { name, value } = e.target;
    setForm(prev => ({ ...prev, [name]: value }));
  };

  const submit = async (e) => {
    e.preventDefault();
    if (editing && editing.id) {
      const res = await api.put(`/hotels/${editing.id}`, form);
      onSaved(res.data);
    } else {
      const res = await api.post("/hotels", form);
      onSaved(res.data);
    }
  };

  return (
    <form onSubmit={submit} style={{ marginBottom: 16 }}>
      <input name="name" placeholder="Name" value={form.name} onChange={handleChange} required />
      <input name="address" placeholder="Address" value={form.address} onChange={handleChange} required />
      <input name="rating" placeholder="Rating" value={form.rating} onChange={handleChange} type="number" step="0.1" />
      <input name="roomsAvailable" placeholder="Rooms" value={form.roomsAvailable} onChange={handleChange} type="number" />
      <input name="pricePerNight" placeholder="Price" value={form.pricePerNight} onChange={handleChange} type="number" step="0.01" />
      <button type="submit">{editing ? "Update" : "Create"}</button>
    </form>
  );
}