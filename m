From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH v2] tpm: Check size of response before
 accessing data
Date: Thu, 12 Jan 2017 19:37:39 +0200
Message-ID: <20170112173739.xbzb34o3lmkdat22@intel.com>
References: <1484079341-22088-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <20170112144321.xctny56r4vqfdekg@intel.com>
 <20170112171839.GB12257@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170112171839.GB12257@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 12, 2017 at 10:18:39AM -0700, Jason Gunthorpe wrote:
> On Thu, Jan 12, 2017 at 04:43:21PM +0200, Jarkko Sakkinen wrote:
> > On Tue, Jan 10, 2017 at 03:15:41PM -0500, Stefan Berger wrote:
> > > Make sure that we have not received less bytes than what is indicated
> > > in the header of the TPM response. Also, check the number of bytes in
> > > the response before accessing its data.
> > > 
> > > Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> > 
> > I'm not going to take this. Do the check case by case outside
> > of tpm_trasmit_cmd.
> 
> What? Why on earth would you do that?
> 
> Every caller needs this validation, it makes sense to make it
> mandatory.

OK I guess I buy that...

> Jason

/Jarkko
