import ttkbootstrap as tb
import tkinter as tk
from pyswip import Prolog
from tkinter import messagebox

class CropRotationUI:
    def __init__(self, root):
        self.root = root
        self.root.title("🌱 Crop Rotation Planner 🌱")
        self.root.geometry("500x500")
        self.prolog = Prolog()
        self.prolog.consult("CropRotation.pl")

        self.style = tb.Style("superhero") 
        self.create_widgets()
        self.load_crops()

    def create_widgets(self):
        self.label = tb.Label(self.root, text="Select crops for rotation:", font=("Helvetica", 14))
        self.label.pack(pady=10)

        self.listbox = tk.Listbox(self.root, selectmode="multiple", height=10)
        self.listbox.pack(fill="x", padx=20)

        self.length_label = tb.Label(self.root, text="Number of crops in rotation:", font=("Helvetica", 12))
        self.length_label.pack(pady=(20,5))

        self.length_entry = tb.Entry(self.root, font=("Helvetica", 12))
        self.length_entry.pack(padx=20, fill="x")

        self.find_button = tb.Button(self.root, text="Find Best Rotation", bootstyle="success", command=self.find_best_rotation)
        self.find_button.pack(pady=20)

        self.result_text = tb.Text(self.root, height=10, font=("Consolas", 12))
        self.result_text.pack(fill="both", padx=20, pady=10)

    def load_crops(self):
        self.listbox.delete(0, "end")
        for result in self.prolog.query("crop(Name, _, _, _, _)"):
            self.listbox.insert("end", result["Name"])

    def find_best_rotation(self):
        selected = self.listbox.curselection()
        if not selected:
            messagebox.showwarning("Warning", "Please select at least one crop!")
            return
        crops = [self.listbox.get(i) for i in selected]

        try:
            num = int(self.length_entry.get())
            if num <= 0:
                raise ValueError
        except ValueError:
            messagebox.showerror("Error", "Enter a valid positive integer for number of crops.")
            return

        crops_prolog = "[" + ",".join(crops) + "]"
        query = f"find_best_rotation({crops_prolog}, {num}, BestSeq, BestScore)"
        results = list(self.prolog.query(query, maxresult=1))

        self.result_text.delete(1.0, "end")
        if results:
            self.result_text.insert("end", f"Best Crop Rotation Sequence:\n{results[0]['BestSeq']}\n\nScore: {results[0]['BestScore']}")
        else:
            self.result_text.insert("end", "No valid crop rotation found.")

if __name__ == "__main__":
    app = tb.Window(themename="superhero")
    CropRotationUI(app)
    app.mainloop()
