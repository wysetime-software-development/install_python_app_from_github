import tkinter as tk

def main():
    # Create the main window
    root = tk.Tk()
    root.title("Simple Tkinter Window")

    # Set window size
    root.geometry("300x200")

    # Create a label widget
    label = tk.Label(root, text="Hello, Tkinter!")
    label.pack(pady=20)

    # Create an exit button
    exit_button = tk.Button(root, text="Exit", command=root.quit)
    exit_button.pack(pady=20)

    # Run the application
    root.mainloop()

if __name__ == "__main__":
    main()
