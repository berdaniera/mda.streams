% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/modernize_metab_model.R
\name{modernize_metab_model}
\alias{modernize_metab_model}
\title{Update a metabolism model from SB to meet current formatting requirements}
\usage{
modernize_metab_model(metab_model)
}
\arguments{
\item{metab_model}{a model or list of models}
}
\description{
Known changes since first models include:
}
\details{
(1) config was the entire info slot, now is an element named config in a list
that is the info slot.

(2) config df has more columns now; old columns have not changed names or 
contents.

(3a) the column named 'local.time' in early fits is now named 'solar.time'.

(3b) the column named 'date' in early fits and 'local.date' and 'solar.date' 
in later rounds is now [again] named 'date'.

(4) the args list may be expanded from before and is now named specs and is
of class specs.
}

