From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [tpmdd-devel] [RFC] tpm2-space: add handling for global session
 exhaustion
Date: Thu, 09 Feb 2017 11:24:15 -0800
Message-ID: <1486668255.2616.43.camel@HansenPartnership.com>
References: <201702090906.v1996c6a015552@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <201702090906.v1996c6a015552@wind.enjellic.com>
Sender: owner-linux-security-module@vger.kernel.org
To: greg@enjellic.com, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Ken Goldman <kgoldman@us.ibm.com>, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, 2017-02-09 at 03:06 -0600, Dr. Greg Wettstein wrote:
> Referring back to Ken's comments about having 20+ clients waiting to
> get access to the hardware.  Even with the focus in TPM2 on having it
> be more of a cryptographic accelerator are we convinced that the
> hardware is ever going to be fast enough for a model of having it
> directly service large numbers of transactions in something like a
> 'cloud' model?

It's already in use as such today:

https://tectonic.com/assets/pdf/TectonicTrustedComputing.pdf

We're also planning something like this in the IBM Cloud.

James

