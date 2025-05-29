# Crop Rotation Planner

This project is a **Crop Rotation Planner** that helps farmers or agricultural planners determine the best crop rotation sequence based on nitrogen balance, soil health, pest resistance, and known agricultural best practices.

It consists of:
- A **Prolog knowledge base** (`CropRotation.pl`) that encodes information about crops and evaluates different sequences.
- A **Python GUI** (`crop_rotation_ui.py`) built using `ttkbootstrap` and `pyswip` to provide an easy-to-use interface for users.

---

## Files

- `CropRotation.pl`: Contains Prolog logic and knowledge base about crop characteristics and their rotation compatibility.
- `crop_rotation_ui.py`: Python script using Tkinter and `pyswip` to interact with the Prolog backend and display results via GUI.

---

## Features

- Select crops from a list.
- Specify how many crops to include in the rotation.
- Get the **best crop rotation sequence** with a computed score.
- Friendly UI with a modern dark theme (`ttkbootstrap`).

---

## Logic Behind Scoring

The system evaluates crop rotation sequences using:
- **Nitrogen Balance** between successive crops
- **Soil Health Transition**
- **Predefined rotation quality** (excellent, good, poor, terrible)

Each pair of consecutive crops is scored and totaled to find the best rotation.

---

## Requirements

Ensure you have the following Python packages installed:

```bash
pip install ttkbootstrap pyswip
