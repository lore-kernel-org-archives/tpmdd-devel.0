From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v5] tpm: Check size of response before accessing data
Date: Mon, 16 Jan 2017 15:25:12 +0200
Message-ID: <20170116132512.zyzt4gflticb6xz2@intel.com>
References: <1484361394-13581-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <20170116132409.i2y7ipchsohqfqxz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170116132409.i2y7ipchsohqfqxz@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 16, 2017 at 03:24:09PM +0200, Jarkko Sakkinen wrote:
> On Fri, Jan 13, 2017 at 09:36:34PM -0500, Stefan Berger wrote:
> > Make sure that we have not received less bytes than what is indicated
> > in the header of the TPM response. Also, check the number of bytes in
> > the response before accessing its data.
> > 
> > Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> 
> There are some things that I want to comment after all but I can give
> now
> 
> Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> I also noticed that this patch is not CC'd to linux-kernel.

Please go through the whole patch and remove arithmetic
from every possible place where you only end up with a
constant.

/Jarkko
