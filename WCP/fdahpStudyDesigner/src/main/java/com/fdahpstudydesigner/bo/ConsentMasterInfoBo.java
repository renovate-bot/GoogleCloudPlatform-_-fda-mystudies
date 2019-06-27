/*******************************************************************************
 * Copyright � 2017-2019 Harvard Pilgrim Health Care Institute (HPHCI) and its Contributors. 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all copies or substantial
 * portions of the Software.
 * 
 * Funding Source: Food and Drug Administration (�Funding Agency�) effective 18 September 2014 as
 * Contract no. HHSF22320140030I/HHSF22301006T (the �Prime Contract�).
 * 
 * THE SOFTWARE IS PROVIDED "AS IS" ,WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
 * PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
 * OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 ******************************************************************************/
package com.fdahpstudydesigner.bo;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * The persistent class for the consent_master_info database table.
 * 
 * @author BTC
 *
 */
@Entity
@Table(name = "consent_master_info")
public class ConsentMasterInfoBo implements Serializable {

	/**
	 *
	 */
	private static final long serialVersionUID = -6253318527840616692L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Integer id;

	@Column(name = "title")
	private String title;

	@Column(name = "type")
	private String type;

	public Integer getId() {
		return id;
	}

	public String getTitle() {
		return title;
	}

	public String getType() {
		return type;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public void setType(String type) {
		this.type = type;
	}

}