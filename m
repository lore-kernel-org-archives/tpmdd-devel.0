From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v3 1/3] tpm: vtpm_proxy: Implement new ioctl to get
 supported flags
Date: Thu, 4 May 2017 11:31:30 -0600
Message-ID: <20170504173130.GA20449@obsidianresearch.com>
References: <1493909787-1848-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1493909787-1848-2-git-send-email-stefanb@linux.vnet.ibm.com>
 <20170504153416.GA15930@obsidianresearch.com>
 <56703d75-b238-0bad-386a-5b6963e250a1@linux.vnet.ibm.com>
 <20170504172042.GA19932@obsidianresearch.com>
 <cfa2642e-5b6e-de69-b1a0-ddcbfaf691c6@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cfa2642e-5b6e-de69-b1a0-ddcbfaf691c6@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, jarkko.sakkinen@linux.intel.com, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, May 04, 2017 at 01:28:17PM -0400, Stefan Berger wrote:

> >So allowing request_locality to fail from userspace seems reasonable.
> 
> What's the best interface to use for this ?

If locality support is enabled then send a request locality packet to
userspace and block until return, just like command execution?

Jason
