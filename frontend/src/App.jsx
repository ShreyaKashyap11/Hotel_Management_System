import React, { useEffect, useState } from "react";
import api from "./api";
import HotelForm from "./components/HotelForm";

function App() {
  const [hotels, setHotels] = useState([]);
  const [editing, setEditing] = useState(null);

  const load = async () => {
    const res = await api.get("/hotels");
    setHotels(res.data);
  };

  useEffect(() => {
    load();
  }, []);

  const handleDelete = async (id) => {
    await api.delete(`/hotels/${id}`);
    setHotels(hotels.filter(h => h.id !== id));
  };

  const handleEdit = (hotel) => {
    setEditing(hotel);
  };

  const onSaved = (saved) => {
    if (editing) {
      setHotels(hotels.map(h => (h.id === saved.id ? saved : h)));
    } else {
      setHotels([saved, ...hotels]);
    }
    setEditing(null);
  };

  return (
    <div style={{ padding: 20 }}>
      <h1>Hotel Management</h1>
      <HotelForm editing={editing} onSaved={onSaved} />
      <hr />
      <h2>Hotels</h2>
      <table border="1" cellPadding="6" style={{ borderCollapse: "collapse", width: "100%" }}>
        <thead>
          <tr>
            <th>Name</th>
            <th>Address</th>
            <th>Rating</th>
            <th>Rooms</th>
            <th>Price</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {hotels.map(h => (
            <tr key={h.id}>
              <td>{h.name}</td>
              <td>{h.address}</td>
              <td>{h.rating}</td>
              <td>{h.roomsAvailable}</td>
              <td>{h.pricePerNight}</td>
              <td>
                <button onClick={() => handleEdit(h)}>Edit</button>{" "}
                <button onClick={() => handleDelete(h.id)}>Delete</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default App;