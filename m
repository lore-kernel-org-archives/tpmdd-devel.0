From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: vtpm_proxy: Do not access host's event log
Date: Thu, 17 Nov 2016 15:43:20 -0800
Message-ID: <20161117234320.bla4cvabblnfxgth@intel.com>
References: <1479306245-14456-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <20161116153731.pmmnxiai7ouuj6qf@intel.com>
 <3a38ddc6-1758-ae82-3df3-9cc55906880d@linux.vnet.ibm.com>
 <65f392b6-5141-c726-dacb-a1649ea215de@linux.vnet.ibm.com>
 <20161116200759.GA19593@obsidianresearch.com>
 <ef1f954d-fc52-0522-01f7-b0e31ea14c59@linux.vnet.ibm.com>
 <20161117181006.GA26039@obsidianresearch.com>
 <c6e84bc7-151c-e698-e269-0ef1ebf3897b@linux.vnet.ibm.com>
 <20161117183328.GC26039@obsidianresearch.com>
 <513da75c-6221-39ce-2718-19290c216ff1@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <513da75c-6221-39ce-2718-19290c216ff1@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, nayna@linux.vnet.ibm.com, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Nov 17, 2016 at 06:15:20PM -0500, Stefan Berger wrote:
> On 11/17/2016 01:33 PM, Jason Gunthorpe wrote:
> > On Thu, Nov 17, 2016 at 01:25:54PM -0500, Stefan Berger wrote:
> > > In the case of x86, tpm_read_log_of() is a stub return -ENODEV, which in
> > > turn fails the whole device:
> > Somehow this got screwed up during the lengthy review. ENODEV is the
> > right return from the leaf routines but the tests in tpm_eventlog di
> > not get fixed:
> > 
> > > http://git.infradead.org/users/jjs/linux-tpmdd.git/blob/4d388433e85f8257f5a9344a7acf6f499ba2b29e:/drivers/char/tpm/tpm_eventlog.h#l87
> > Is wrong, should be:
> > 
> > if (rc != -ENODEV)
> >     return rc;
> > 
> > And the one in tpm_bios_log_setup should be
> > 
> > if (rc != 0 && rc != -ENODEV)
> >      return rc;
> 
> 
> Can you show a patch that shows where to place these two?

The disasterous error handling for cases that you mentioned:

http://git.infradead.org/users/jjs/linux-tpmdd.git/commitdiff/d660a91a1b9dd80f5c2c973e3369400d3c9f9848

I'm sorry I let these slip in the code review.

/Jarkko
