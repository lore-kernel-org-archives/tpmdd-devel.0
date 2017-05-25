From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: vtpm_proxy: Do not run tpm2_shutdown
Date: Thu, 25 May 2017 15:00:48 -0600
Message-ID: <20170525210048.GA14592@obsidianresearch.com>
References: <1495717956-14252-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <20170525155059.GA5151@obsidianresearch.com>
 <f6c024ae-fe93-251a-a176-1f27f25b1e21@linux.vnet.ibm.com>
 <20170525200931.GA12733@obsidianresearch.com>
 <9ff88c24-ca7a-1867-7284-17689fdac655@linux.vnet.ibm.com>
 <20170525204414.GA13742@obsidianresearch.com>
 <cf746443-5ef5-211f-6b62-a5d4d66e27fd@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cf746443-5ef5-211f-6b62-a5d4d66e27fd@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: jarkko.sakkinen@linux.intel.com, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, May 25, 2017 at 04:54:01PM -0400, Stefan Berger wrote:

> This particular command will never reach anyone listening on the proxy's
> file descriptor since the tear-down only begins when the front- and backend
> are closed.

> The logging happens somewhere else than where the error occurs. What is the
> best way to suppress the logging? Remove it entirely  -- probably not.
> Return a special error code that doesn't get logged?

Error code would be my choice.

> that indicates this condition? It's not clear to me. Why not just
> prevent the command from being sent if it will never reach its
> intended destination

There are many cases where the vtpm shutdown can race with something
else, if the logging for this is bothersome it should be fixed
directly.

Adding strange special case flags is confusing as to the purpose - eg
your commit message didn't even say this is only about fixing some
noisy logging.

Jason
