From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/3] tpm: vtpm_proxy: Implement new ioctl to get
 supported flags
Date: Thu, 4 May 2017 13:33:41 -0400
Message-ID: <08065914-2b96-ca1d-2fe0-344472ed9691@linux.vnet.ibm.com>
References: <1493909787-1848-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1493909787-1848-2-git-send-email-stefanb@linux.vnet.ibm.com>
 <20170504153416.GA15930@obsidianresearch.com>
 <56703d75-b238-0bad-386a-5b6963e250a1@linux.vnet.ibm.com>
 <20170504172042.GA19932@obsidianresearch.com>
 <cfa2642e-5b6e-de69-b1a0-ddcbfaf691c6@linux.vnet.ibm.com>
 <20170504173130.GA20449@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170504173130.GA20449@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, jarkko.sakkinen@linux.intel.com, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 05/04/2017 01:31 PM, Jason Gunthorpe wrote:
> On Thu, May 04, 2017 at 01:28:17PM -0400, Stefan Berger wrote:
>
>>> So allowing request_locality to fail from userspace seems reasonable.
>> What's the best interface to use for this ?
> If locality support is enabled then send a request locality packet to
> userspace and block until return, just like command execution?

We would have to invent a command for that...


