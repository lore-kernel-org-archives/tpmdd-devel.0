From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RFC 4/4] tpm: add the infrastructure for TPM space for
 TPM 2.0
Date: Tue, 3 Jan 2017 02:37:30 +0200
Message-ID: <20170103003730.he32vl55kkta2q64@intel.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
 <20170102132213.22880-5-jarkko.sakkinen@linux.intel.com>
 <20170102210953.GB5544@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170102210953.GB5544@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 02, 2017 at 02:09:53PM -0700, Jason Gunthorpe wrote:
> On Mon, Jan 02, 2017 at 03:22:10PM +0200, Jarkko Sakkinen wrote:
> > Added a ioctl for creating a TPM space. The space is isolated from the
> > other users of the TPM. Only a process holding the file with the handle
> > can access the objects and only objects that are created through that
> > file handle can be accessed.
> 
> I don't understand this comment. /dev/tpmX is forced to be
> single-process-open, so how can there ever be more than 1 FD for it?
> 
> Since the space is tied to that single fd these patches just create a
> way for the single user-space process to auto-cleanup if it crashes?
> 
> Is that the entire intent of this design? I guess it is OK as a
> stepping point..

is_open is cleared in tpm_ioc_new_space.

/Jarkko
