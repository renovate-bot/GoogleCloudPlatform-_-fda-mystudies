/*
 * Copyright 2021 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 */

package com.google.cloud.healthcare.fdamystudies.bean;

import java.util.LinkedList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class Answer {

  private Boolean valueBoolean;
  private Double valueDecimal;
  private Integer valueInteger;
  private String valueDateTime;
  private String valueDate;
  private String valueTime;
  private String valueString;
  private List<ItemsQuestionnaireResponse> item = new LinkedList<>();
}
