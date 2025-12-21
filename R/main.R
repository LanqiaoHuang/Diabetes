#' Predict Diabetes Risk Using Pretrained Models
#'
#' This function takes a data.frame of patient features and returns diabetes risk
#' classification ("Yes" or "No") based on a pretrained model stored as an .rds file.
#' Supports Random Forest ("rf"), Logistic Regression ("glm"), and SVM ("svm").
#'
#' @param newdata A data.frame containing the predictor variables. It must include
#'                columns: Pregnancies, Glucose, BloodPressure, SkinThickness,
#'                Insulin, BMI, DiabetesPedigreeFunction, Age.
#' @param threshold Numeric classification threshold between 0 and 1 (default 0.5).
#'                  Probabilities above this threshold are classified as "Yes".
#' @param model_type Character model type: "rf" for Random Forest, "glm" for Logistic Regression,
#'                   "svm" for Support Vector Machine. Default is "rf".
#' @return A data.frame including all columns of newdata plus two additional columns:
#'         \code{Pred_Prob} (predicted probability for "Yes") and
#'         \code{Pred_Class} (predicted class factor with levels "No" and "Yes").
#' @examples
#' \dontrun{
#' df <- data.frame(
#'  Pregnancies = c(2, 0),
#'  Glucose = c(120, 85),
#'  BloodPressure = c(70, 65),
#'  SkinThickness = c(20, 30),
#'  Insulin = c(79, 88),
#'  BMI = c(31.0, 25.5),
#'  DiabetesPedigreeFunction = c(0.5, 0.3),
#'  Age = c(45, 32)
#' )
#' predict_diabetes(df, model_type = "rf")
#' predict_diabetes(df, model_type = "glm", threshold = 0.4)
#' predict_diabetes(df, model_type = "svm", threshold = 0.6)
#' }
#' @importFrom e1071 predict
#' @export
predict_diabetes <- function(newdata, threshold = 0.5, model_type = "rf") {

  required_cols <- c("Pregnancies", "Glucose", "BloodPressure", "SkinThickness",
                     "Insulin", "BMI", "DiabetesPedigreeFunction", "Age")
  missing_cols <- setdiff(required_cols, colnames(newdata))
  if(length(missing_cols) > 0) {
    stop("Input data.frame is missing required columns: ", paste(missing_cols, collapse = ", "))
  }

  model_path <- switch(model_type,
                       rf = system.file("extdata", "diabetes_rf_model.rds", package = "Diabetes"),
                       glm = system.file("extdata", "diabetes_glm_model.rds", package = "Diabetes"),
                       svm = system.file("extdata", "diabetes_svm_model.rds", package = "Diabetes"),
                       stop("Unsupported model_type. Choose 'rf', 'glm', or 'svm'."))

  if(model_path == "") stop("Cannot find model file for the selected model type.")

  model <- readRDS(model_path)

  if(model_type == "rf") {
    probs <- predict(model, newdata, type = "prob")[, "Yes"]
  } else if(model_type == "glm") {
    probs <- predict(model, newdata, type = "response")
  } else if(model_type == "svm") {
    pred_obj <- predict(model, newdata, probability = TRUE)
    probs <- attr(pred_obj, "probabilities")[, "Yes"]
  }

  classes <- ifelse(probs > threshold, "Yes", "No")

  result <- cbind(newdata,
                  Pred_Prob = round(probs, 3),
                  Pred_Class = factor(classes, levels = c("No", "Yes")))

  return(result)
}
