import openpyxl
import os

file_path = "TestData.xlsx"
if not os.path.exists(file_path):
    print(f"Error: {file_path} not found")
else:
    wb = openpyxl.load_workbook(file_path)
    sheet = wb.active
    headers = [cell.value for cell in sheet[1]]
    print(f"Headers: {headers}")
