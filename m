From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: Fix expected number of response bytes of TPM1.2 PCR
 Extend
Date: Fri, 17 Feb 2017 20:45:46 +0200
Message-ID: <20170217184546.ik2vv5bleahqhkwv@intel.com>
References: <1487177783-15687-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <20170215180903.3simazptqnlhbqi6@intel.com>
 <1487335598.15611.9.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487335598.15611.9.camel@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>, Stefan Berger <stefanb@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Feb 17, 2017 at 07:46:38AM -0500, Mimi Zohar wrote:
> Hi James,
> 
> On Wed, 2017-02-15 at 20:09 +0200, Jarkko Sakkinen wrote:
> > On Wed, Feb 15, 2017 at 11:56:23AM -0500, Stefan Berger wrote:
> > > The TPM1.2 PCR Extend operation only returns 20 bytes in the body,
> > > which is the size of the PCR state.
> > > 
> > > This fixes a problem where IMA gets errors with every PCR Extend.
> > > 
> > > Fixes: c659af78eb7b ("tpm: Check size of response before accessing data")
> > > Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> > > Acked-by: Mimi Zohar <zohar@us.ibm.com>
> > 
> > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> This patch needs to be included with the rest of the patches being
> upstreamed in the next open window.   Should Jarkko or I send you a pull
> request for it?
> 
> thanks,
> 
> Mimi

I'm sending a pull request after the weekend. It will contain
only a few small scoped fixes so wouldn't it be easiest if I
just include this to the pack?

/Jarkko
