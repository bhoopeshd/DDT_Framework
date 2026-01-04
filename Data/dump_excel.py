import openpyxl

file_path = "TestData.xlsx"
wb = openpyxl.load_workbook(file_path)
sheet = wb.active

print("--- Excel Content ---")
for row in sheet.iter_rows(values_only=True):
    print(row)
print("---------------------")
