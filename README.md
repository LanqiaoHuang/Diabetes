# Diabetes — A pre-trained model based diabetes risk prediction package

[![CRAN Status](https://www.r-pkg.org/badges/version/Diabetes)](https://cran.r-project.org/package=Diabetes)  
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)  
[![R build status](https://github.com/LanqiaoHuang/Diabetes/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/LanqiaoHuang/Diabetes/actions)

Diabetes is a lightweight R package that provides diabetes risk prediction based on pre-trained models. Users do not need to train models themselves — simply supply common clinical/phenotypic variables to obtain probability-based risk predictions.

Data source
```r
https://www.kaggle.com/datasets/kandij/diabetes-dataset/data
```
---
## Structure
```r
Diabetes/
├── DESCRIPTION
├── NAMESPACE
├── R/
│   └── main.R   # Put the function code here
├── inst/
│   └── extdata/
│       ├── diabetes_rf_model.rds
│       ├── diabetes_glm_model.rds
│       └── diabetes_svm_model.rds
```

---

## Highlights

- ✨ Pre-trained models: ready to use out of the box, no training required  
- ⚖️ Multiple algorithms: supports Random Forest (RF), Logistic Regression (GLM), and Support Vector Machine (SVM)  
- 🎯 Customizable threshold: returns probabilities and allows a custom classification threshold  
- 🔌 Easy integration: returns a clean data.frame for downstream analysis or visualization  
- 🧪 Suitable for quick prototyping and small-scale clinical data evaluation

---

## Installation

The current version is not yet published on CRAN. You can install the development version from GitHub:

```r
# Run once to install devtools (if not already installed)
install.packages("devtools")

# Install from GitHub
devtools::install_github("LanqiaoHuang/Diabetes")
```

After installation, load the package:

```r
library(Diabetes)
```

---

## Quick start (example)

The example below shows how to use the default Random Forest model to predict and view probabilities and classification results:

```r
# Construct example patient data
patient_data <- data.frame(
  Pregnancies = c(2, 0),
  Glucose = c(120, 85),
  BloodPressure = c(70, 65),
  SkinThickness = c(20, 30),
  Insulin = c(79, 88),
  BMI = c(31.0, 25.5),
  DiabetesPedigreeFunction = c(0.5, 0.3),
  Age = c(45, 32)
)

# Use the default model (random forest), default threshold 0.5
pred_rf <- predict_diabetes(patient_data)
print(pred_rf)
```

The output will contain the original features plus two columns:
- `Pred_Prob`: predicted probability of diabetes (0–1)
- `Pred_Class`: binary classification result, values `"No"` or `"Yes"`

You can specify model and threshold:

```r
pred_glm <- predict_diabetes(patient_data, model_type = "glm", threshold = 0.4)
pred_svm <- predict_diabetes(patient_data, model_type = "svm", threshold = 0.6)
```

---

## Function Reference

### predict_diabetes(newdata, threshold = 0.5, model_type = "rf")
Use `?predict_diabetes` for help.  
```r
??predict_diabetes
```

Description: Predicts diabetes risk for new patients using the package's pre-trained models, returning probabilities and binary classifications.

Parameters:
- `newdata` (data.frame): Must contain the following columns (case-sensitive)  
  - `Pregnancies` (numeric): Number of pregnancies  
  - `Glucose` (numeric): Plasma glucose concentration  
  - `BloodPressure` (numeric): Diastolic blood pressure (mm Hg)  
  - `SkinThickness` (numeric): Triceps skinfold thickness (mm)  
  - `Insulin` (numeric): 2-Hour serum insulin (mu U/ml)  
  - `BMI` (numeric): Body mass index  
  - `DiabetesPedigreeFunction` (numeric): Diabetes pedigree function  
  - `Age` (numeric): Age (years)

- `threshold` (numeric, 0–1): Samples with probability greater than this threshold are classified as `"Yes"` (default 0.5)  
- `model_type` (character): Choice of pre-trained model, supported values: `"rf"` (random forest, default), `"glm"` (logistic regression), `"svm"` (support vector machine)

Returns: A data.frame containing the original features plus two columns: `Pred_Prob` (probability) and `Pred_Class` (factor: `"No"`/`"Yes"`).

Note: Input data must be preprocessed appropriately (no missing values, correct numeric types, etc.) to avoid errors.

---

## Dependencies

- randomForest — Random Forest models  
- e1071 — SVM (probability estimates must be enabled)  
- stats — Logistic regression (base R)

These dependencies are typically installed automatically during package installation if missing.

---

## Usage recommendations and notes

- If your data contains missing values, please impute or remove missing samples first.  
- Predictions are outputs of statistical models and should be used together with clinical judgment; they should not be used alone for diagnostic decisions.  
- If you plan to use these models on large real-world datasets, validate model performance on the target population first (AUC, sensitivity, specificity, etc.).

---

## Contributing

Issues, feature requests, and pull requests to contribute code, improve pre-trained models, or add additional evaluation metrics are welcome. Please follow the repository's contribution guidelines and code of conduct (if available).

---

## License

This project is licensed under the MIT License. See the LICENSE file for details.

---

## Contact

If you have questions or collaboration inquiries, please contact:  
Lanqiao Huang — LanqiaoHuang@example.com  
Project homepage: <https://github.com/LanqiaoHuang/Diabetes>

---

Thank you for using Diabetes! If you'd like, I can help generate a GitHub Actions CI configuration, package documentation (pkgdown), or an example dataset.
```

